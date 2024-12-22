//
//  RemoteConfig.swift
//  RemoteControlApp
//
//  Created by Zafran on 11/10/2024.
//

import SwiftUI
import FirebaseRemoteConfig
import GoogleMobileAds
import Firebase
import Combine

class AdViewModel: ObservableObject {
    @Published var bannerAdID: String?
    
    init() {
        fetchBannerAdID()
    }
    
    func fetchBannerAdID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
#if DEBUG
                self.bannerAdID = "ca-app-pub-3940256099942544/2435281174999"
#else
                self.bannerAdID = remoteConfig["bannerAdID"].stringValue
#endif
                
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class isRateModel: ObservableObject {
    @Published var israte: Int?
    
    init() {
        fetchisRate()
    }
    
    func fetchisRate() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.israte = remoteConfig["israte"].numberValue.intValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class nativeViewModel: ObservableObject {
    @Published var nativeAdID: String?
    
    init() {
        fetchNativeAdID()
    }
    
    func fetchNativeAdID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
#if DEBUG
                self.nativeAdID = "ca-app-pub-3940256099942544/3986624511999"
#else
                self.nativeAdID = remoteConfig["smallNativeAdID"].stringValue
#endif
                
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class mailViewModel: ObservableObject {
    @Published var mailID: String? = "Patrickridd10@icloud.com"
    
    init() {
        fetchMailID()
    }
    
    func fetchMailID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.mailID = remoteConfig["mailID"].stringValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class appLinkModel: ObservableObject {
    @Published var shareAppID: String?
    
    init() {
        fetchshareAppID()
    }
    
    func fetchshareAppID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.shareAppID = remoteConfig["shareApp"].stringValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class termsAndConditionModel: ObservableObject {
    @Published var termsAndConditionID: String?
    
    init() {
        fetchtermsAndConditionID()
    }
    
    func fetchtermsAndConditionID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.termsAndConditionID = remoteConfig["termsAndCondition"].stringValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class eulaModel: ObservableObject {
    @Published var eulaID: String?
    
    init() {
        fetcheulaID()
    }
    
    func fetcheulaID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.eulaID = remoteConfig["eula"].stringValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class privacyModel: ObservableObject {
    @Published var privacyPolicy: String?
    
    init() {
        privacyPolicyID()
    }
    
    func privacyPolicyID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.privacyPolicy = remoteConfig["privacyPolicy"].stringValue
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class InterstitialViewModel: ObservableObject {
    @Published var InterstitialAdID: String?
    
    init() {
        fetchInterstitialAdID()
    }
    
    func fetchInterstitialAdID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                
#if DEBUG
                self.InterstitialAdID = "ca-app-pub-3940256099942544/4411468910999"
#else
                self.InterstitialAdID = remoteConfig["interstitialAdID"].stringValue
#endif
                
                
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class RemoteConfigManager: ObservableObject {
    @Published var interstitialShowAtEvery: Int?
    
    init() {
        fetchRemoteConfig()
    }
    
     func fetchRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.interstitialShowAtEvery = remoteConfig["interstitialShowAtEvery"].numberValue.intValue
                print(self.interstitialShowAtEvery ?? "nil value")
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class OpenAppViewModel: ObservableObject {
    @Published var openAppAdID: String?
    var adIDPublisher = PassthroughSubject<String, Never>()
    
    init() {
        fetchOpenAppAdID()
    }
    
    func fetchOpenAppAdID() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
#if DEBUG
                self.openAppAdID = "ca-app-pub-3940256099942544/5575463023999"
                self.adIDPublisher.send(remoteConfig["openAppAdID"].stringValue)
#else
                self.openAppAdID = remoteConfig["openAppAdID"].stringValue
                self.adIDPublisher.send(remoteConfig["openAppAdID"].stringValue)
#endif
                
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class umpModel: ObservableObject {
    @Published var UMP: Bool?
    
    init() {
        getUmp()
    }
    
    func getUmp() {
        if UMP != nil {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let remoteConfig = RemoteConfig.remoteConfig()
            remoteConfig.fetchAndActivate { status, error in
                if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                    DispatchQueue.main.async {
                        self.UMP = remoteConfig["UMP"].boolValue
                        print("UMP fetched: \(String(describing: self.UMP))")
                    }
                } else {
                    print("Error fetching remote config: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

class showButtonModel: ObservableObject {
    @Published var showhomebutton: Bool?
    
    init() {
        getShowButton()
    }
    
    func getShowButton() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                DispatchQueue.main.async {
                    self.showhomebutton = remoteConfig["showhomebutton"].boolValue
                    print("UMP fetched: \(String(describing: self.showhomebutton))")
                }
            }
        }
    }
}

class RemoteConfigManagerPermission: ObservableObject {
    @Published var adpermissions: [String] = []
    
    init() {
        fetchRemoteConfig()
    }
    
    func fetchRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate {  status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                DispatchQueue.main.async {
                    self.parseAdPermissions(remoteConfig: remoteConfig)
                }
            } else {
                print("Error fetching remote config: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func parseAdPermissions(remoteConfig: RemoteConfig) {
        // Retrieve the value as an array directly instead of expecting a dictionary
        let adpermissions = remoteConfig.configValue(forKey: "adpermissions").jsonValue
        print(adpermissions)

        // Check if adpermissions can be cast as an array of strings
        if let permissionsArray = adpermissions as? [String] {
            self.adpermissions = permissionsArray
            print("Parsed adpermissions: \(self.adpermissions)")
        } else {
            print("Failed to parse adpermissions.")
        }
    }
}
