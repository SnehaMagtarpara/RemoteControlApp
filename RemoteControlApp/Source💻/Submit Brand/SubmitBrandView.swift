//
//  BottomSheetView.swift
//  RemoteControlApp
//
//  Created by Zafran on 09/10/2024.
//

import SwiftUI
import MessageUI

struct BottomSheetView: View {
    @Binding var showMailComposer: Bool
    @Binding var brandName: String
    @Binding var modelName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment:.leading, spacing: 15) {
           
            Text("Can't find the Channel you're\nlooking for?".localized)
                .font(.system(size: 24, type: .Bold))
                .foregroundStyle(Color.tintstatic)
            
            Text("Tell us the brand and model you need, and we'll update it soon!".localized)
                
                .font(.system(size: 12, type: .Regular))
                .foregroundStyle(Color.tintstatic)
            
            
            VStack(spacing: 15) {
                
                TextField("Enter Brand Name".localized, text: $brandName)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color.secondaryFill)
                    .foregroundStyle(Color.tintTertiary)
                    .cornerRadius(10)
                
                TextField("Enter Model Name".localized, text: $modelName)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color.secondaryFill)
                    .foregroundStyle(Color.tintTertiary)
                    .cornerRadius(10)
                    
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    if MFMailComposeViewController.canSendMail() {
                            showMailComposer = true
                        }
                }) {
                    Text("Submit".localized)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.primaryMain)
                        .font(.system(size: 18, type: .Bold))
                        .foregroundStyle(Color.tintstatic)
                        .clipShape(Capsule())
                }
                
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel".localized)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, type: .Bold))
                        .foregroundColor(Color.secondaryMain)
                        .multilineTextAlignment(.center)
                }
                
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondaryBg)
    }
}
