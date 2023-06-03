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
import CoreMotion

public final class DeviceServiceImpl: DeviceService {
    
    private let batteryLevelPublisher: CurrentValueSubject<Int?, Never>!
    private let batteryStatePublisher: CurrentValueSubject<BatteryState, Never>!
    private let batteryLowPowerModePublisher: CurrentValueSubject<BatteryLowPowerMode, Never>!
    private let screenBrightnessPublisher: CurrentValueSubject<Int, Never>!
    private let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
    private var cancellables = Set<AnyCancellable>()
    
    private let uiDevice: UIDevice
    private let device: MyDevice
    private let processInformation: ProcessInfo
    private let notificationCenter: DeviceNotificationCenter
    private let application: UIApplication
    private let screen: MyScreen
    
    public init(
        uiDevice: UIDevice = .current,
        device: MyDevice = Device.current,
        processInformation: ProcessInfo,
        notificationCenter: DeviceNotificationCenter = NotificationCenter.default,
        application: UIApplication,
        screen: MyScreen = UIScreen.main
    ) {
        self.uiDevice = uiDevice
        self.device = device
        self.processInformation = processInformation
        self.notificationCenter = notificationCenter
        self.application = application
        self.screen = screen
        
        uiDevice.isBatteryMonitoringEnabled = true
        
        batteryLevelPublisher = CurrentValueSubject(device.batteryLevel)
        batteryStatePublisher = CurrentValueSubject(device.batteryState?.mapToBatteryState ?? .none)
        batteryLowPowerModePublisher = CurrentValueSubject(processInformation.isLowPowerModeEnabled.mapToLowPowerMode)
        screenBrightnessPublisher = CurrentValueSubject(screen.screenBrightness)
        
        notificationCenter
            .publisher(for: UIDevice.batteryLevelDidChangeNotification, object: nil)
            .compactMap { _ in
                device.batteryLevel
            }
            .sink { [unowned self] in
                batteryLevelPublisher.send($0)
            }
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UIDevice.batteryStateDidChangeNotification, object: nil)
            .compactMap { _ in
                device.batteryState?.mapToBatteryState
            }
            .sink { [unowned self] in
                batteryStatePublisher.send($0)
            }
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: Notification.Name.NSProcessInfoPowerStateDidChange, object: nil)
            .map { _ in
                processInformation.isLowPowerModeEnabled.mapToLowPowerMode
            }
            .sink { [unowned self] in
                batteryLowPowerModePublisher.send($0)
            }
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UIScreen.brightnessDidChangeNotification, object: nil)
            .map { _ in
                screen.screenBrightness
            }
            .sink { [unowned self] in
                screenBrightnessPublisher.send($0)
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
                    architecture: cpuArchitecture,
                    cores: processInformation.processorCount,
                    activeCores: processInformation.activeProcessorCount
                ),
                thermalState: mapToThermalState(device.thermalState),
                isJailbroken: application.canOpenURL(URL(string: "cydia://")!),
                multitasking: uiDevice.isMultitaskingSupported
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
                    has3dTouch: device.has3dTouchSupport,
                    resolution: .init(
                        x: Int(screen.bounds.size.width * screen.scale),
                        y: Int(screen.bounds.size.height * screen.scale)
                    )
                ),
                camera: .init(
                    lidarSensor: device.hasLidarSensor,
                    telephoto: device.hasTelephotoCamera,
                    wide: device.hasWideCamera,
                    ultraWide: device.hasUltraWideCamera,
                    torch: AVCaptureDevice.default(for: .video)?.hasTorch ?? false
                ),
                counting: .init(
                    steps: CMPedometer.isStepCountingAvailable(),
                    pace: CMPedometer.isPaceAvailable(),
                    distance: CMPedometer.isDistanceAvailable(),
                    floors: CMPedometer.isFloorCountingAvailable(),
                    cadence: CMPedometer.isCadenceAvailable()
                ),
                disk: .init(
                    totalSpace: uiDevice.totalDiskSpaceInGB,
                    usedSpace: uiDevice.usedDiskSpaceInGB,
                    freeSpace: uiDevice.freeDiskSpaceInGB,
                    totalSpaceRaw: uiDevice.totalDiskSpaceInBytes,
                    usedSpaceRaw: uiDevice.usedDiskSpaceInBytes,
                    freeSpaceRaw: uiDevice.freeDiskSpaceInBytes
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
    
    public func screenBrightness() -> AnyPublisher<Int, Never> {
        screenBrightnessPublisher
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
    
    private var cpuArchitecture: DeviceInformation.CPU.Architecture {
        #if os(iOS)
            #if arch(arm64)
                return .arm64
            #elseif arch(arm) || arch(arm64_32)
                return .arm
            #else
                return .unknown
            #endif
        #else
            return .unknown
        #endif
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
