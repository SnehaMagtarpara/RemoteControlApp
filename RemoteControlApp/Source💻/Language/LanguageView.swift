//
//  LanguageView.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var appLanguage: AppLanguage
    @State private var selectedLanguage: String = "English"
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject private var adIDViewModel = AdViewModel()
    
    let languages: [(name: String, code: String)] = [
        ("English", "en"),
        ("العربية", "ar"),
        ("Português", "pt"),
        ("Français", "fr"),
        ("Türkçe", "tr"),
        ("Indonesia", "id"),
        ("Dutch", "nl")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar
            HStack {
                
                Spacer()
                
                Text("Language".localized)
                    .font(.system(size: 18, type: .Bold))
                    .foregroundColor(Color.tintstatic)
                
                Spacer()
                
                Button(action: {
                    appState.hasSeenLanguage = true
                }) {
                    Image("checkmarkImage")
                        
                }
            }
            .padding()
            .background(Color.secondaryBg)
            
            // List of languages
            List {
                ForEach(languages, id: \.code) { language in
                    LanguageRow(language: language.name, code: language.code, selectedLanguageCode: $appLanguage.currentLanguage)
                }
                //.listRowBackground(Color.secondaryBg)
                .listRowInsets(EdgeInsets())
                
                
                
            }
            .scrollContentBackground(.hidden)
            .listRowSpacing(15)
            Spacer()
            
            if !userViewModel.isSubscriptionActive {
                if let bannerAdID = adIDViewModel.bannerAdID {
                    BannerAdView(adUnitID: bannerAdID)
                        .frame(height: 55)
                }
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct LanguageRow: View {
    let language: String
    let code: String
    @Binding var selectedLanguageCode: String
    
    var body: some View {
        HStack {
            if code == selectedLanguageCode {
                Text(language)
                    .font(.system(size: 17, type: .Bold))
                    .foregroundColor(Color.tintstatic)
            } else {
                Text(language)
                    .font(.system(size: 17, type: .Regular))
                    .foregroundColor(Color.tintTertiary)
            }
            
            Spacer()
            
            if code == selectedLanguageCode {
                Image("check")
            } else {
                Image("uncheck")
            }
        }
        .padding()
        .background(code == selectedLanguageCode ? Color.rowBg : Color.secondaryBg)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedLanguageCode = code
            UserDefaults.standard.set(code, forKey: "selectedLanguageCode")
            Bundle.setLanguage(code)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(code == selectedLanguageCode ? Color.Primary : Color.tertiaryBg, lineWidth: 4)
        )
    }
}

#Preview {
    LanguageSelectionView()
}
