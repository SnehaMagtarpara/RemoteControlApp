//
//  AppState.swift
//  RemoteControlApp
//
//  Created by Zafran on 11/10/2024.
//

import SwiftUI

class AppState: ObservableObject {
    
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        }
    }
    
    @Published var hasSeenLanguage: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenLanguage, forKey: "hasSeenLanguage")
        }
    }
    
    @Published var hasSeenSelectTVBrand: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenSelectTVBrand, forKey: "hasSeenSelectTVBrand")
        }
    }
    
    @Published var hasSeenImportantNotes: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenImportantNotes, forKey: "hasSeenImportantNotes")
        }
    }
    
    
    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.hasSeenLanguage = UserDefaults.standard.bool(forKey: "hasSeenLanguage")
        self.hasSeenSelectTVBrand = UserDefaults.standard.bool(forKey: "hasSeenSelectTVBrand")
        self.hasSeenImportantNotes = UserDefaults.standard.bool(forKey: "hasSeenImportantNotes")
    }
    
}
