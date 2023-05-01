//
//  ApplePencilSupport.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public enum ApplePencilSupport {
    case firstGen
    case secondGen
    case none
}

public extension ApplePencilSupport {
    
    var localisedTitle: String {
        switch self {
        case .firstGen:
            return "First Generation Supported"
        case .secondGen:
            return "First Generation Supported"
        case .none:
            return "Not Supported"
        }
    }
    
}
