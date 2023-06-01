//
//  DeviceExtension.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import DeviceKit
import Foundation

public protocol MyDevice {
    var batteryLevel: Int? { get }
    var batteryState: Device.BatteryState? { get }
    var safeDescription: String { get }
    var systemName: String? { get }
    var systemVersion: String? { get }
    var cpu: Device.CPU { get }
    var thermalState: Device.ThermalState? { get }
    var applePencilSupport: Device.ApplePencilSupport { get }
    var supportsWirelessCharging: Bool { get }
    var isTouchIDCapable: Bool { get }
    var isFaceIDCapable: Bool { get }
    var isZoomed: Bool? { get }
    var diagonal: Double { get }
    var hasRoundedDisplayCorners: Bool { get }
    var ppi: Int? { get }
    var has3dTouchSupport: Bool { get }
    var hasLidarSensor: Bool { get }
    var hasTelephotoCamera: Bool { get }
    var hasWideCamera: Bool { get }
    var hasUltraWideCamera: Bool { get }
}

extension Device: MyDevice { }
