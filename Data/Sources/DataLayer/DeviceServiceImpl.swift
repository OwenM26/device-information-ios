//
//  DeviceServiceImpl.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation
import DeviceKit
import Combine
import MachO

public final class DeviceServiceImpl: DeviceService {
    
    private let device: Device
    private let processInformation: ProcessInfo
    
    public init(
        device: Device,
        processInformation: ProcessInfo
    ) {
        self.device = device
        self.processInformation = processInformation
    }
    
    public func deviceInformation() -> AnyPublisher<DeviceInformation, Never> {
        Just(
            DeviceInformation(
                name: device.model,
                os: [device.systemName, device.systemVersion]
                    .compactMap { $0 }
                    .joined(separator: " "),
                cpu: .init(
                    processor: device.cpu.description,
                    architecture: cpuArchitecture
                ),
                thermalState: mapToThermalState(device.thermalState),
                uptime: processInformation.systemUptime
            )
        )
        .eraseToAnyPublisher()
    }
    
    public func applePencilSupport() -> AnyPublisher<ApplePencilSupport, Never> {
        Just(mapApplePencilSupport(device.applePencilSupport))
            .eraseToAnyPublisher()
    }
    
    public func supportsWirelessCharging() -> AnyPublisher<Bool, Never> {
        Just(device.supportsWirelessCharging)
            .eraseToAnyPublisher()
    }
    
}

extension DeviceServiceImpl {
    
    private func mapApplePencilSupport(_ pencilSupport: Device.ApplePencilSupport) -> ApplePencilSupport {
        switch pencilSupport {
        case .firstGeneration:
            return .firstGen
        case .secondGeneration:
            return .secondGen
        default:
            return .none
        }
    }
    
    private var cpuArchitecture: String {
        guard let archRaw = NXGetLocalArchInfo().pointee.name else {
            return ""
        }
        return String(cString: archRaw)
    }
    
    private func mapToThermalState(_ state: Device.ThermalState?) -> DeviceInformation.ThermalState {
        switch state {
        case .nominal:
            return .nominal
        case .fair:
            return .fair
        case .serious:
            return .serious
        case .critical:
            return .critical
        default:
            return .nominal
        }
    }
    
}
