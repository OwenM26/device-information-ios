//
//  BatteryState.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public enum BatteryState {
    case full, charging, unplugged
}

public extension BatteryState {
    
    var localisedString: String {
        switch self {
        case .full:
            return NSLocalizedString("batteryState.full", bundle: .module, comment: "")
        case .charging:
            return NSLocalizedString("batteryState.charging", bundle: .module, comment: "")
        case .unplugged:
            return NSLocalizedString("batteryState.unplugged", bundle: .module, comment: "")
        }
    }
    
}
