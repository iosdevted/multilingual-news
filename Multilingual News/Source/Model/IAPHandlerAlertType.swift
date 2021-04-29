//
//  IAPHandlerAlertType.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import Foundation

enum IAPHandlerAlertType {
    case disabled
    case restored
    case purchased
    
    func message() -> String {
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}
