//
//  OnboardingView.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    @EnvironmentObject var appState: AppState
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.primaryBg
                .ignoresSafeArea(.all)
            VStack(spacing: 78)
            {
                Image("onboarding")
                
                Text("Personalize Your\n TV Remote Experience".localized)
                    .font(.system(size: 28, type: .Bold))
                    .foregroundStyle(Color.tintStatic)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    appState.hasSeenOnboarding = true
                }, label: {
                    Text("Start Now".localized)
                        .font(.system(size: 16, type: .Bold))
                        
                })
                .frame(width: 255, height: 55)
                .background(Color.primaryMain)
                .foregroundStyle(Color.tintStatic)
                .clipShape(Capsule())
            }
            
        }//ZStack
    }
}
#Preview {
    OnboardingView()
}
