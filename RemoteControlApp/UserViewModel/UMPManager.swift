//
//  UMPManager.swift
//  RemoteControlApp
//
//  Created by Zafran on 11/10/2024.
//

import Foundation
import SwiftUI
import UserMessagingPlatform
import GoogleMobileAds
import AdSupport

class UMPManager {
    
    static let shared = UMPManager()
    
    var canRequestAds: Bool {
        return UMPConsentInformation.sharedInstance.canRequestAds
    }

    var isPrivacyOptionsRequired: Bool {
        return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required
    }
    
    private var isMobileAdsStartCalled = false
    
    func gatherConsent(from consentFormPresentationViewController: UIViewController, consentGatheringComplete: @escaping (Error?) -> Void) {
        let parameters = UMPRequestParameters()
        #if DEBUG
        let debugSettings = UMPDebugSettings()
        debugSettings.testDeviceIdentifiers = ["366D40D1-3E1A-4EF7-A53C-B30700A789E9"]
        debugSettings.geography = .EEA
        parameters.tagForUnderAgeOfConsent = false
        parameters.debugSettings = debugSettings
        #endif
        
        // Requesting consent info update
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { requestError in
            guard requestError == nil else {
                return consentGatheringComplete(requestError)
            }
            
            let consentStatus = UMPConsentInformation.sharedInstance.consentStatus
            print("Consent status: \(consentStatus.rawValue)")
            
            if consentStatus == .required {
                // If consent is required, load and present the form
                UMPConsentForm.loadAndPresentIfRequired(from: consentFormPresentationViewController) { presentError in
                    consentGatheringComplete(presentError)
                }
            } else {
                // Consent not required or already gathered
                consentGatheringComplete(nil)
            }
        }
    }
    
    func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            self.isMobileAdsStartCalled = true
            GADMobileAds.sharedInstance().start()
        }
    }
    
    func presentPrivacyOptionsForm(from viewController: UIViewController, completionHandler: @escaping (Error?) -> Void) {
        UMPConsentForm.presentPrivacyOptionsForm(from: viewController, completionHandler: completionHandler)
    }
}

struct FormViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
