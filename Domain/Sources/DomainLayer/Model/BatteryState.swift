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
            return "Fully Charged"
        case .charging:
            return "Charging"
        case .unplugged:
            return "Discharging"
        }
    }
    
}
