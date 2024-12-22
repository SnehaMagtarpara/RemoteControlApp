//
//  ContentView.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @EnvironmentObject var appState: AppState
    // MARK: - Body
    var body: some View {
        Group {
            if !appState.hasSeenOnboarding {
                OnboardingView()
                    .environmentObject(appState)
                
            }else if !appState.hasSeenLanguage {
                LanguageSelectionView()
                    .environmentObject(appState)
            }
            else if !appState.hasSeenSelectTVBrand {
                SelectTVBrandView()
                    .environmentObject(appState)
            }
            else if !appState.hasSeenImportantNotes {
                ImportantNotesView()
                    .environmentObject(appState)
            }
            else {
                HomeView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    ContentView()
}
