//
//  Font.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import Foundation
import SwiftUI

extension Font {
    static func system(size:CGFloat,type:FontAlexandriaType = .Regular) -> Font{
        self.custom(type.rawValue, size: size)
    }
}

enum FontAlexandriaType:String {
    case Black = "Roboto-Black"
    case Bold = "Roboto-Bold"
    case Medium = "Roboto-Medium"
    case Regular = "Roboto-Regular"
    case Light = "Roboto-Light"
    case Thin = "Roboto-Thin"
}
