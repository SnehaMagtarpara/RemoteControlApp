//
//  ImportantNotesView.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import Foundation
import SwiftUI

struct ImportantNotesView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLottieAnimation: Bool = false
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Text("Important Notes".localized)
                        .font(.system(size: 18, type: .Bold))
                        .foregroundColor(Color.tintstatic)
                    
                    Spacer()
                }
                .padding()
                .background(Color.secondaryBg)
                
                
                Image("bannerImage")
                
                
                
                Text("Before we get started, please\nensure the following".localized)
                    .font(.system(size: 22, type: .Bold))
                    .foregroundColor(Color.tintstatic)
                    .multilineTextAlignment(.center)
                
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    
                    InstructionRow(number: "1", instruction: "Your TV is turned on and ready, making sure all connections are properly set up and it’s in a powered state for the next steps.".localized)
                    
                    InstructionRow(number: "2", instruction: "Both your phone and TV are connected to the same Wi-Fi network to enable seamless pairing and communication between the devices.".localized)
                    
                    InstructionRow(number: "3", instruction: "If your phone is connected to a VPN, kindly turn it off to avoid any potential connectivity issues that may interfere with the process.".localized)
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    UserDefaults.standard.set(0, forKey: "isRateCount")
                    showLottieAnimation.toggle()
                }) {
                    Text("Ready".localized)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.primaryMain)
                        .font(.system(size: 18, type: .Bold))
                        .foregroundStyle(Color.tintstatic)
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            if showLottieAnimation {
                VStack {
                    Text("Successfully Remote Connected".localized)
                        .font(.system(size: 22, type: .Bold))
                        .foregroundStyle(Color.tintstatic)
                    LottieView(filename: "sucessfully")
                        .frame(width: 200, height: 200)
                        .onAppear {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                appState.hasSeenImportantNotes = true
                            }
                        }
                }
                .padding()
                .cornerRadius(15)
                .background(Color.black)
            }
        }
        
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct InstructionRow: View {
    let number: String
    let instruction: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(number).")
                .font(.system(size: 34, type: .Bold))
                .foregroundColor(Color.tintTertiary)
                
            
            Text(instruction)
                .font(.system(size: 16, type: .Regular))
                .foregroundColor(Color.tintTertiary)
                .lineLimit(nil)
        }
    }
}

struct ImportantNotesView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantNotesView()
    }
}
