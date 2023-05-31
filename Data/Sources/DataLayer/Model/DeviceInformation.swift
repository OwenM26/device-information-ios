//
//  DeviceInformation.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public struct DeviceInformation {
    
    public struct CPU {
        
        public enum Architecture {
            case arm64, arm, unknown
        }
        
        public let processor: String
        public let architecture: Architecture
        public let cores: Int
        public let activeCores: Int
    }
    
    public enum ThermalState {
        case nominal
        case fair
        case serious
        case critical
    }
    
    public let name: String?
    public let os: String
    public let cpu: CPU
    public let thermalState: ThermalState
    public let isJailbroken: Bool
    public let multitasking: Bool
}
