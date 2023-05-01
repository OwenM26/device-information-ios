//
//  Support.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public enum Support {
    case yes, no
}

public extension Support {
    
    var systemImageName: String {
        switch self {
        case .yes:
            return "checkmark"
        case .no:
            return "xmark"
        }
    }
    
}
