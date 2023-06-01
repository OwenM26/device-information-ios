//
//  MockDevice.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import DeviceKit
import Foundation
@testable import DataLayer

final class MockDevice: MyDevice {
    
    init() { }
    
    var batteryLevel: Int?
    
    var batteryState: Device.BatteryState?
    
    var safeDescription: String {
        "Test Simulator"
    }
    
    var systemName: String?
    
    var systemVersion: String?
    
    var cpu: Device.CPU {
        .unknown
    }
    
    var thermalState: Device.ThermalState?
    
    var applePencilSupport: Device.ApplePencilSupport {
        .firstGeneration
    }
    
    var supportsWirelessCharging: Bool {
        false
    }
    
    var isTouchIDCapable: Bool {
        false
    }
     
    var isFaceIDCapable: Bool {
        true
    }
    
    var isZoomed: Bool?
    
    var diagonal: Double {
        100
    }
    
    var hasRoundedDisplayCorners: Bool {
        true
    }
    
    var ppi: Int?
    
    var has3dTouchSupport: Bool {
        true
    }
    
    var hasLidarSensor: Bool {
        true
    }
    
    var hasTelephotoCamera: Bool {
        true
    }
    
    var hasWideCamera: Bool {
        true
    }
    
    var hasUltraWideCamera: Bool {
        true
    }
    
}
