//
//  UserViewModel.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import Foundation
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    
    init() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            
            self.isSubscriptionActive = customerInfo?.entitlements.all["Pro"]?.isActive == true
        }
    }
}
