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
        public let cores: Int
        public let activeCores: Int
        
        public init(
            processor: String,
            architecture: String,
            cores: Int,
            activeCores: Int
        ) {
            self.processor = processor
            self.architecture = architecture
            self.cores = cores
            self.activeCores = activeCores
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
    public let isJailbroken: Support
    public let multitasking: Support
    
    public init(
        name: String?,
        os: String,
        cpu: CPU,
        thermalState: ThermalState,
        uptime: String,
        lastReboot: Date,
        isJailbroken: Support,
        multitasking: Support
    ) {
        self.name = name
        self.os = os
        self.cpu = cpu
        self.thermalState = thermalState
        self.uptime = uptime
        self.lastReboot = lastReboot
        self.isJailbroken = isJailbroken
        self.multitasking = multitasking
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
