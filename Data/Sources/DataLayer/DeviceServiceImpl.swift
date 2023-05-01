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
import AVKit

public final class DeviceServiceImpl: DeviceService {
    
    private let batteryLevelPublisher: CurrentValueSubject<Int?, Never>!
    private let batteryStatePublisher: CurrentValueSubject<BatteryState, Never>!
    private let batteryLowPowerModePublisher: CurrentValueSubject<BatteryLowPowerMode, Never>!
    private var cancellables = Set<AnyCancellable>()
    
    private let uiDevice: UIDevice
    private let device: Device
    private let processInformation: ProcessInfo
    private let notificationCenter: NotificationCenter
    
    public init(
        uiDevice: UIDevice,
        device: Device,
        processInformation: ProcessInfo,
        notificationCenter: NotificationCenter
    ) {
        self.uiDevice = uiDevice
        self.device = device
        self.processInformation = processInformation
        self.notificationCenter = notificationCenter
        
        uiDevice.isBatteryMonitoringEnabled = true
        
        batteryLevelPublisher = CurrentValueSubject(device.batteryLevel)
        batteryStatePublisher = CurrentValueSubject(device.batteryState?.mapToBatteryState ?? .none)
        batteryLowPowerModePublisher = CurrentValueSubject(processInformation.isLowPowerModeEnabled.mapToLowPowerMode)
        
        notificationCenter
            .publisher(for: UIDevice.batteryLevelDidChangeNotification)
            .compactMap { _ in
                device.batteryLevel
            }
            .sink { [unowned self] in
                batteryLevelPublisher.send($0)
            }
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UIDevice.batteryStateDidChangeNotification)
            .compactMap { _ in
                device.batteryState?.mapToBatteryState
            }
            .sink { [unowned self] in
                batteryStatePublisher.send($0)
            }
            .store(in: &cancellables)
        
        processInformation
            .publisher(for: \.isLowPowerModeEnabled)
            .map {
                $0.mapToLowPowerMode
            }
            .sink { [unowned self] in
                batteryLowPowerModePublisher.send($0)
            }
            .store(in: &cancellables)
    }
    
    public func deviceInformation() -> AnyPublisher<DeviceInformation, Never> {
        Just(
            DeviceInformation(
                name: device.safeDescription,
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
    
    public func deviceSupport() -> AnyPublisher<DeviceSupport, Never> {
        Just(
            DeviceSupport(
                applePencil: mapApplePencilSupport(device.applePencilSupport),
                wirelessCharging: device.supportsWirelessCharging,
                touchID: device.isTouchIDCapable,
                faceID: device.isFaceIDCapable,
                display: .init(
                    zoomed: device.isZoomed ?? false,
                    diagonal: device.diagonal,
                    roundedCorners: device.hasRoundedDisplayCorners,
                    ppi: device.ppi ?? 0,
                    has3dTouch: device.has3dTouchSupport
                ),
                camera: .init(
                    lidarSensor: device.hasLidarSensor,
                    telephoto: device.hasTelephotoCamera,
                    wide: device.hasWideCamera,
                    ultraWide: device.hasUltraWideCamera,
                    torch: AVCaptureDevice.default(for: .video)?.hasTorch ?? false
                )
            )
        )
        .eraseToAnyPublisher()
    }
    
    public func batteryLevel() -> AnyPublisher<Int?, Never> {
        batteryLevelPublisher
            .eraseToAnyPublisher()
    }
    
    public func batteryState() -> AnyPublisher<BatteryState, Never> {
        batteryStatePublisher
            .eraseToAnyPublisher()
    }
    
    public func batteryLowPowerMode() -> AnyPublisher<BatteryLowPowerMode, Never> {
        batteryLowPowerModePublisher
            .eraseToAnyPublisher()
    }
    
}

extension DeviceServiceImpl {
    
    private func mapApplePencilSupport(_ pencilSupport: Device.ApplePencilSupport) -> DeviceSupport.ApplePencilSupport {
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

extension Bool {
    
    fileprivate var mapToLowPowerMode: BatteryLowPowerMode {
        self ? .on : .off
    }
    
}

extension Device.BatteryState {
    
    fileprivate var mapToBatteryState: BatteryState {
        switch self {
        case .full:
            return .full
        case .charging:
            return .charging
        case .unplugged:
            return .unplugged
        }
    }
    
}
