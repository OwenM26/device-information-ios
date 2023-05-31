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
        
        public init(
            processor: String,
            architecture: Architecture,
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
    public let isJailbroken: Support
    public let multitasking: Support
    
    public init(
        name: String?,
        os: String,
        cpu: CPU,
        thermalState: ThermalState,
        isJailbroken: Support,
        multitasking: Support
    ) {
        self.name = name
        self.os = os
        self.cpu = cpu
        self.thermalState = thermalState
        self.isJailbroken = isJailbroken
        self.multitasking = multitasking
    }
}

public extension DeviceInformation.CPU.Architecture {
    
    var localisedString: String {
        switch self {
        case .arm64:
            return NSLocalizedString("cpu.architecture.arm64", bundle: .module, comment: "")
        case .arm:
            return NSLocalizedString("cpu.architecture.arm", bundle: .module, comment: "")
        case .unknown:
            return NSLocalizedString("cpu.architecture.unknown", bundle: .module, comment: "")
        }
    }
    
}

public extension DeviceInformation.ThermalState {
    
    var localisedString: String {
        switch self {
        case .normal:
            return NSLocalizedString("thermalState.normal", bundle: .module, comment: "")
        case .fair:
            return NSLocalizedString("thermalState.fair", bundle: .module, comment: "")
        case .serious:
            return NSLocalizedString("thermalState.serious", bundle: .module, comment: "")
        case .critical:
            return NSLocalizedString("thermalState.critical", bundle: .module, comment: "")
        }
    }
    
}
