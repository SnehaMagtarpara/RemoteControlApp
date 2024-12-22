//
//  AppOpenAdManager.swift
//  RemoteControlApp
//
//  Created by Zafran on 11/10/2024.
//

import Foundation
import GoogleMobileAds
import UIKit

class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
    static let shared = AppOpenAdManager()
    private var appOpenAd: GADAppOpenAd?
    private var loadTime: Date?
    private var isAdShowing = false
    
    private override init() {}
    
    func loadAd(adUnitID: String) {
        GADAppOpenAd.load(withAdUnitID: adUnitID,
                          request: GADRequest(),
                          completionHandler: { [weak self] ad, error in
            if let error = error {
                print("Failed to load app open ad: \(error.localizedDescription)")
                NotificationCenter.default.post(name: NSNotification.Name("AdDismissed"), object: nil)
                return
            }
            self?.appOpenAd = ad
            self?.appOpenAd?.fullScreenContentDelegate = self
            self?.loadTime = Date()
            print("Open Ad loaded successfully")
            if let rootViewController = UIApplication.shared.rootViewController {
                self?.showAdIfAvailable(rootViewController, adUnitID: adUnitID)
            }
        })
    }

    func showAdIfAvailable(_ viewController: UIViewController, adUnitID: String) {
        guard let ad = appOpenAd, wasLoadTimeLessThanNHoursAgo(threshold: 2), !isAdShowing else {
            print("Ad not available or too recent, loading new ad")
            loadAd(adUnitID: adUnitID)
            return
        }
        print("Presenting ad")
        isAdShowing = true
        ad.present(fromRootViewController: viewController)
    }
    
    private func wasLoadTimeLessThanNHoursAgo(threshold: Int) -> Bool {
        guard let loadTime = loadTime else { return false }
        let timeIntervalSinceLoad = Date().timeIntervalSince(loadTime)
        let hoursSinceLoad = timeIntervalSinceLoad / 3600.0
        return hoursSinceLoad < Double(threshold)
    }
    
    // MARK: - GADFullScreenContentDelegate
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present ad: \(error.localizedDescription)")
        isAdShowing = false
        NotificationCenter.default.post(name: NSNotification.Name("AdDismissed"), object: nil)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        isAdShowing = false

        // Notify to change the state in the app
        NotificationCenter.default.post(name: NSNotification.Name("AdDismissed"), object: nil)
    }
}

extension UIApplication {
    var rootViewController: UIViewController? {
        return windows.first?.rootViewController
    }
}
