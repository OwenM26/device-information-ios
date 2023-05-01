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
    func applePencilSupport() -> AnyPublisher<ApplePencilSupport, Never>
    func supportsWirelessCharging() -> AnyPublisher<Bool, Never>
}
