//
//  DeviceInformation.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public struct DeviceInformation {
    
    public struct CPU {
        public let processor: String
        public let architecture: String
        
        public init(
            processor: String,
            architecture: String
        ) {
            self.processor = processor
            self.architecture = architecture
        }
    }
    
    public enum ThermalState {
        case normal
        case fair
        case serious
        case critical
    }
    
    public let name: String?
    public let os: String
    public let cpu: CPU
    public let thermalState: ThermalState
    public let uptime: String
    public let lastReboot: Date
    
    public init(
        name: String?,
        os: String,
        cpu: CPU,
        thermalState: ThermalState,
        uptime: String,
        lastReboot: Date
    ) {
        self.name = name
        self.os = os
        self.cpu = cpu
        self.thermalState = thermalState
        self.uptime = uptime
        self.lastReboot = lastReboot
    }
}

public extension DeviceInformation.ThermalState {
    
    var localisedString: String {
        switch self {
        case .normal:
            return "Normal"
        case .fair:
            return "Fair"
        case .serious:
            return "Serious"
        case .critical:
            return "Critical"
        }
    }
    
}
