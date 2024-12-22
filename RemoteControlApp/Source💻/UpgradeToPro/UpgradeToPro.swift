//
//  UpgradeToPro.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import SwiftUI
import RevenueCat

struct UpgradeToPro: View {
    // MARK: - Properties
    @Binding var isGoToUpgradePro: Bool
    @ObservedObject private var termsAndConditionID = termsAndConditionModel()
    @ObservedObject private var privacyPolicyID = privacyModel()
    @ObservedObject private var EULA = eulaModel()
    
    @ObservedObject private var remoteConfigMg = RemoteConfigManagerPermission()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var selectedOption: SubscriptionOption? = .yearly
    @State var currentOffering: Offering?
    
    @State private var isLoading: Bool = false
    
    enum SubscriptionOption {
        case weekly, monthly,yearly
        
        var title: String {
            switch self {
            case .weekly:
                return "Weekly"
            case .yearly:
                return "Yearly"
            case .monthly:
                return "Monthly"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image("probg")
            .ignoresSafeArea(.all)
            ScrollView {
                
                VStack(spacing: 15){
                    Spacer()
                    Spacer()
                    HStack{
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("close")
                        })
                        Spacer()
                        // MARK: - Restore
                        Button(action: {
                            Purchases.shared.restorePurchases { customerInfo, error in
                                userViewModel.isSubscriptionActive = customerInfo?.entitlements.all["Pro"]?.isActive == true
                                if userViewModel.isSubscriptionActive {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }, label: {
                            Text("Restore".localized)
                                .font(.system(size: 16, type: .Bold))
                                .foregroundColor(Color.primaryMain)
                        })
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7.5)
                        .background(Color.white)
                        .clipShape(Capsule())
                        
                        
                    }
                    .padding(.top, 0)
                    
                    Image("probanner")
                    
                    VStack(alignment: .center,spacing: 21){
                        Text("Upgrade to premium".localized)
                            .font(.system(size: 20, type: .Bold))
                            .foregroundColor(Color.tintstatic)
                            .multilineTextAlignment(.center)
                        Text("For access to advanced features and a superior experience!".localized)
                            .font(.system(size: 12, type: .Regular))
                            .foregroundColor(Color.tintstatic)
                            .multilineTextAlignment(.center)
                        HStack {
                            VStack(alignment: .leading, spacing: 21) {
                                
                                ForEach(remoteConfigMg.adpermissions, id: \.self) { permission in
                                    upgradeOfferView(title: permission)
                                }
                                
                            }
                            Spacer()
                        }
                        
                    }
                    
                    
                    VStack(spacing: 16) {
                        
                        // Pricing options
                        HStack(spacing: 16) {
                            if let currentOffering = currentOffering {
                                // Loop through available packages
                                ForEach(currentOffering.availablePackages, id: \.self) { pkg in
                                    let option = subscriptionOption(for: pkg )
                                    
                                    // Set isBestValue to true only for the lifetime option
                                    let isBestValue = option == .yearly
                                    
                                    SubscriptionOptionView(
                                        title: "\(option?.title ?? "")",
                                        price: pkg.storeProduct.localizedPriceString,
                                        description: "\(pkg.storeProduct.localizedPriceString)/\(option?.title ?? "")",
                                        isBestValue: isBestValue,
                                        isSelected: selectedOption == option
                                    )
                                    .onTapGesture {
                                        selectedOption = option
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            purchaseSelectedOption()
                        }, label: {
                            Text("Owned It".localized)
                                .font(.system(size: 16, type: .Bold))
                                .foregroundColor(Color.tintStatic)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(
                                    Color.secondaryMain
                                )
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        })
                        VStack {
                            // Introductory text
                            Text("By subscribing you indicate that you agree with our")
                                .font(.system(size: 13, type: .Regular))
                                .foregroundColor(Color.tintTertiary)
                            
                            // Privacy Policy link
                            HStack(spacing: 0) {
                                Text(" ")
                                Text("Privacy Policy")
                                    .font(.system(size: 12, type: .Bold))
                                    .underline()
                                    .foregroundColor(Color.primaryMain)
                                    .onTapGesture {
                                        privacyPolicy()
                                    }
                                
                                Text(", ")
                                    .foregroundColor(Color.tintTertiary)
                                // Terms of Use link
                                Text("Terms of Use")
                                    .font(.system(size: 12, type: .Bold))
                                    .underline()
                                    .foregroundColor(Color.primaryMain)
                                    .onTapGesture {
                                        termsAndCondition()
                                    }
                                
                                Text(" and ")
                                    .foregroundColor(Color.tintTertiary)
                                // EULA link
                                Text("EULA")
                                    .font(.system(size: 12, type: .Bold))
                                    .underline()
                                    .foregroundColor(Color.primaryMain)
                                    .onTapGesture {
                                        EULAFunc()
                                    }
                                
                                Text(".")
                                    .foregroundColor(Color.tintTertiary)
                            }
                            .font(.system(size: 13, type: .Regular))
                            .multilineTextAlignment(.center)
                            
                            // Any other view elements...
                        }
                        .multilineTextAlignment(.center)
                    }

                    
                    
                }
                .padding(.horizontal, 16)
                .padding([.bottom, .top])
            }
            .scrollIndicators(.hidden)
            
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(.all)
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }//:ZStack
        .onAppear {
            remoteConfigMg.fetchRemoteConfig()
            Purchases.shared.getOfferings { offering, error in
                if let offer = offering?.current, error == nil {
                    
                    currentOffering = offer
                    print(offer)
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - Helper Functions
    func subscriptionOption(for package: Package) -> SubscriptionOption? {

        // Otherwise, return based on the period unit
        switch package.storeProduct.subscriptionPeriod?.unit {
        case .week:
            return .weekly
        case .month:
            return .monthly
        case .year:
            return .yearly
        default:
            return nil
        }
    }
    
    func purchaseSelectedOption() {
        
        guard let selectedOption = selectedOption, let package = currentOffering?.availablePackages.first(where: { subscriptionOption(for: $0) == selectedOption }) else {
            return
        }
        isLoading = true
        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
            if userCancelled {
                isLoading = false
                
            } else if let error = error {
                isLoading = false
                
            } else {
                isLoading = false
                if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                    userViewModel.isSubscriptionActive = true
                    isGoToUpgradePro.toggle()
                }
            }
        }
    }
    
    func openURL(_ urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    
    func privacyPolicy() {
        
        if let privacyLink = privacyPolicyID.privacyPolicy, let url = URL(string: privacyLink) {
            
            UIApplication.shared.open(url)
        }
    }
    
    func termsAndCondition() {
        
        if let privacyLink = termsAndConditionID.termsAndConditionID, let url = URL(string: privacyLink) {
            
            UIApplication.shared.open(url)
        }
    }
    
    func EULAFunc() {
        
        if let privacyLink = EULA.eulaID, let url = URL(string: privacyLink) {
            
            UIApplication.shared.open(url)
        }
    }
}
    
    struct SubscriptionOptionView: View {
        let title: String
        let price: String
        let description: String
        var isBestValue: Bool = false
        let isSelected: Bool
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                if isBestValue {
                    
                    HStack {
                        Spacer()
                        Image("best")
                            .resizable()
                            .frame(width: 32, height: 22)
                        Spacer()
                    }
                }
                
                VStack(alignment: .center, spacing: 10) {
                    if !isBestValue {
                        Spacer()
                    }
                    Text(title)
                        .font(.system(size: 16, type: .Bold))
                        .foregroundColor(Color.tintTertiary)
                    
                    
                    VStack(alignment:.center, spacing: 10){
                        
                        Text(price)
                            .font(.system(size: 22, type: .Bold))
                            .foregroundColor(Color.primaryMain)
                        
                        
                        // Description
                        Text(description)
                            .font(.system(size: 14, type: .Bold))
                            .lineLimit(2)
                            .foregroundColor(Color.tintTertiary)
                        
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom)
                .padding(.top, 10)
                
                Spacer()
            }
            .frame(width: 115,height: 140)
            .background(Color.secondaryBg)
            .cornerRadius(14)
            .shadow(radius: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.primaryMain : Color.clear, lineWidth: 2)
            )
        }
    }
    
    struct upgradeOfferView: View {
        var title: String = ""
        var body: some View {
            HStack {
                Image("star")
                Text(title)
                    .font(.system(size: 12,type: .Regular))
                    .foregroundStyle(Color.tintstatic)
            }
        }
    }
