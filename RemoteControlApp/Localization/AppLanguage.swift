//
//  AppLanguage.swift
//  RemoteControlApp
//
//  Created by Zafran on 16/10/2024.
//

import Foundation
import SwiftUI

class AppLanguage: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguageCode")
            Bundle.setLanguage(currentLanguage)
            objectWillChange.send()
        }
    }

    init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? "en"
        Bundle.setLanguage(currentLanguage)
    }
}

// MARK: - Bundle Extension
extension Bundle {
    // Change from private to internal or fileprivate
    static var localizedBundle: Bundle?

    class func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return
        }
        self.localizedBundle = bundle
    }

    class func localizedString(forKey key: String, value: String? = nil, table tableName: String? = nil) -> String {
        return (self.localizedBundle ?? Bundle.main).localizedString(forKey: key, value: value, table: tableName)
    }
}

// MARK: - String Extension
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle ?? Bundle.main, value: "", comment: "")
    }
}
