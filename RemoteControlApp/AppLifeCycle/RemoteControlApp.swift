//
//  RemoteControlApp.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI
import CoreData
import UIKit
import UserNotifications
import FirebaseCore
import GoogleMobileAds
import FirebaseRemoteConfig
import RevenueCat
import Combine
import AppTrackingTransparency
import AdSupport
import UserMessagingPlatform

class AppData: ObservableObject {
    @Published var adID: String?
}

@main
struct AutoClickApp: App {
    @StateObject var appLanguage = AppLanguage()
    @StateObject var userViewModel = UserViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appData = AppData()
    @StateObject var appState = AppState()
    @StateObject var openAppViewModel = OpenAppViewModel()
    @StateObject private var isUmpEnabled = umpModel()
    @State private var splashScreenPresentWithLoader: Bool = true
    @Environment(\.scenePhase) private var scenePhase
    private var cancellables = Set<AnyCancellable>()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if splashScreenPresentWithLoader {
                    SplashView()
                        .environmentObject(isUmpEnabled)
                        .environmentObject(userViewModel)
                        .environmentObject(appState)
                        .environmentObject(appLanguage)
                        .environmentObject(appData)
                        .environmentObject(openAppViewModel)
                        .onAppear {
                            if isUmpEnabled.UMP == nil {
                                isUmpEnabled.getUmp()
                            }
                        }
                        .onChange(of: isUmpEnabled.UMP) { newValue in
                            if newValue == true {
                                print("UMP is true")
                                upmPopup()
                            } else {
                                trackingPopup()
                            }
                        }
                } else {
                    ContentView()
                        .environmentObject(isUmpEnabled)
                        .environmentObject(userViewModel)
                        .environmentObject(appState)
                        .environmentObject(appLanguage)
                        .environmentObject(appData)
                        .environmentObject(openAppViewModel)
                        .onReceive(NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)) { _ in
                            print("Foreground Active")
                            if !userViewModel.isSubscriptionActive, let adID = openAppViewModel.openAppAdID {
                                AppOpenAdManager.shared.loadAd(adUnitID: adID)
                            }
                        }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AdDismissed"))) { _ in
                splashScreenPresentWithLoader = false
            }
        }
    }
    
    func trackingPopup() {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        self.showOpenAd()
                    case .denied:
                        self.showOpenAd()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func upmPopup() {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            if isUmpEnabled.UMP ?? false {
                UMPManager.shared.gatherConsent(from: rootVC) { error in
                    if let error = error {
                        
                        self.showOpenAd()
                    } else {
                        print("Consent gathered successfully.")
                        if UMPManager.shared.canRequestAds {
                            UMPManager.shared.startGoogleMobileAdsSDK()
                        }
                        self.showOpenAd()
                    }
                }
            }
        }
    }
    
    func showOpenAd() {
        if let adID = openAppViewModel.openAppAdID {
            AppOpenAdManager.shared.loadAd(adUnitID: adID)
        } else {
            AppOpenAdManager.shared.loadAd(adUnitID: "default_ad_id")
        }
    }
    
    func dismissSplashScreen() {
        DispatchQueue.main.async {
            splashScreenPresentWithLoader = false
        }
    }
    
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_oSilwWNkZzfTutiWHxVptYfYjXL")
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
}
