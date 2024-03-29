//
//  DeviceViewModel.swift
//  Device
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation
import DataLayer
import DomainLayer
import Combine

final class DeviceViewModel: ObservableObject {
    
    @Published private(set) var deviceInformation: DomainLayer.DeviceInformation?
    @Published private(set) var deviceSupport: DomainLayer.DeviceSupport?
    @Published private(set) var batteryLevel: String?
    @Published private(set) var batteryState: DomainLayer.BatteryState?
    @Published private(set) var batteryLowPowerMode: DomainLayer.BatteryLowPowerMode?
    @Published private(set) var screenBrightness = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let deviceService: DeviceService
    
    init(
        deviceService: DeviceService = DeviceServiceImpl(
            processInformation: .processInfo,
            application: .shared
        )
    ) {
        self.deviceService = deviceService
        
        fetchData()
    }
    
    func fetchData() {
        fetchDeviceInformation()
        fetchDeviceSupport()
        fetchBatteryLevel()
        fetchBatteryState()
        fetchBatteryLowPowerMode()
        fetchScreenBrightness()
    }
    
    private func fetchDeviceInformation() {
        deviceService
            .deviceInformation()
            .map {
                DomainLayer.DeviceInformation(
                    name: $0.name,
                    os: $0.os,
                    cpu: .init(
                        processor: $0.cpu.processor,
                        architecture: self.mapToCPUArchitecture($0.cpu.architecture),
                        cores: $0.cpu.cores,
                        activeCores: $0.cpu.activeCores
                    ),
                    thermalState: self.mapToThermalState($0.thermalState),
                    isJailbroken: self.mapToSupport($0.isJailbroken),
                    multitasking: self.mapToSupport($0.multitasking)
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                deviceInformation = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchDeviceSupport() {
        deviceService
            .deviceSupport()
            .map {
                DomainLayer.DeviceSupport(
                    applePencil: self.mapToApplePencilSupport($0.applePencil),
                    wirelessCharging: self.mapToSupport($0.wirelessCharging),
                    touchID: self.mapToSupport($0.touchID),
                    faceID: self.mapToSupport($0.faceID),
                    display: .init(
                        zoomed: self.mapToSupport($0.display.zoomed),
                        diagonal: "\($0.display.diagonal)\"",
                        roundedCorners: self.mapToSupport($0.display.roundedCorners),
                        ppi: "\($0.display.ppi) ppi",
                        has3dTouch: self.mapToSupport($0.display.has3dTouch),
                        resolution: .init(
                            x: $0.display.resolution.x,
                            y: $0.display.resolution.y
                        )
                    ),
                    camera: .init(
                        lidarSensor: self.mapToSupport($0.camera.lidarSensor),
                        telephoto: self.mapToSupport($0.camera.telephoto),
                        wide: self.mapToSupport($0.camera.wide),
                        ultraWide: self.mapToSupport($0.camera.ultraWide),
                        torch: self.mapToSupport($0.camera.torch)
                    ),
                    counting: .init(
                        steps: self.mapToSupport($0.counting.steps),
                        pace: self.mapToSupport($0.counting.pace),
                        distance: self.mapToSupport($0.counting.distance),
                        floors: self.mapToSupport($0.counting.floors),
                        cadence: self.mapToSupport($0.counting.cadence)
                    ),
                    disk: .init(
                        totalSpace: $0.disk.totalSpace,
                        usedSpace: $0.disk.usedSpace,
                        freeSpace: $0.disk.freeSpace,
                        totalSpaceRaw: $0.disk.totalSpaceRaw,
                        usedSpaceRaw: $0.disk.usedSpaceRaw,
                        freeSpaceRaw: $0.disk.freeSpaceRaw,
                        chartData: self.mapToDiskChartData(
                            freeSpaceRaw: $0.disk.freeSpaceRaw,
                            usedSpaceRaw: $0.disk.usedSpaceRaw
                        )
                    )
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                deviceSupport = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchBatteryLevel() {
        deviceService
            .batteryLevel()
            .map { "\($0 ?? 0)%" }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                batteryLevel = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchBatteryState() {
        deviceService
            .batteryState()
            .map {
                self.mapToBatteryState($0)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                batteryState = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchBatteryLowPowerMode() {
        deviceService
            .batteryLowPowerMode()
            .map {
                self.mapToBatteryLowPowerModel($0)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                batteryLowPowerMode = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchScreenBrightness() {
        deviceService
            .screenBrightness()
            .map {
                "\($0)%"
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                screenBrightness = $0
            }
            .store(in: &cancellables)
    }
    
}

extension DeviceViewModel {
    
    private func mapToCPUArchitecture(_ architecture: DataLayer.DeviceInformation.CPU.Architecture) -> DomainLayer.DeviceInformation.CPU.Architecture {
        switch architecture {
        case .arm64:
            return .arm64
        case .arm:
            return .arm
        case .unknown:
            return .unknown
        }
    }
    
    private func mapToApplePencilSupport(_ support: DataLayer.DeviceSupport.ApplePencilSupport) -> DomainLayer.DeviceSupport.ApplePencilSupport {
        switch support {
        case .firstGen:
            return .firstGen
        case .secondGen:
            return .secondGen
        case .none:
            return .none
        }
    }
    
    private func mapToThermalState(_ state: DataLayer.DeviceInformation.ThermalState) -> DomainLayer.DeviceInformation.ThermalState {
        switch state {
        case .nominal:
            return .normal
        case .fair:
            return .fair
        case .serious:
            return .serious
        case .critical:
            return .critical
        }
    }
    
    private func mapToSupport(_ value: Bool) -> Support {
        return value ? .yes : .no
    }
    
    private func mapToBatteryState(_ state: DataLayer.BatteryState) -> DomainLayer.BatteryState {
        switch state {
        case .full:
            return .full
        case .charging:
            return .charging
        case .unplugged:
            return .unplugged
        case .none:
            return .unplugged
        }
    }
    
    private func mapToBatteryLowPowerModel(_ state: DataLayer.BatteryLowPowerMode) -> DomainLayer.BatteryLowPowerMode {
        switch state {
        case .on:
            return .on
        case .off:
            return .off
        }
    }
    
    private func mapToDiskChartData(
        freeSpaceRaw: Int64,
        usedSpaceRaw: Int64
    ) -> [DomainLayer.DeviceSupport.Disk.ChartData] {
        [
            .init(
                name: "device.section.storage.usedSpace",
                value: usedSpaceRaw
            ),
            .init(
                name: "device.section.storage.freeSpace",
                value: freeSpaceRaw
            )
        ]
    }
    
}
