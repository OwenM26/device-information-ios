//
//  DeviceService.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation
import Combine

public protocol DeviceService {
    func deviceInformation() -> AnyPublisher<DeviceInformation, Never>
    func deviceSupport() -> AnyPublisher<DeviceSupport, Never>
    func batteryLevel() -> AnyPublisher<Int?, Never>
    func batteryState() -> AnyPublisher<BatteryState, Never>
    func batteryLowPowerMode() -> AnyPublisher<BatteryLowPowerMode, Never>
    func screenBrightness() -> AnyPublisher<Int, Never>
}
