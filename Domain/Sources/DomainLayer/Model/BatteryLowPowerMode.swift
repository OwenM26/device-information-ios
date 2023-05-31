//
//  BatteryLowPowerMode.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public enum BatteryLowPowerMode {
    case on, off
}

public extension BatteryLowPowerMode {
    
    var localisedString: String {
        switch self {
        case .on:
            return NSLocalizedString("enabled", bundle: .module, comment: "")
        case .off:
            return NSLocalizedString("disabled", bundle: .module, comment: "")
        }
    }
    
}
