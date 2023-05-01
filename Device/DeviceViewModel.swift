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
    @Published private(set) var applePencilSupport = DomainLayer.ApplePencilSupport.none
    @Published private(set) var supportsWirelessCharging = Support.no
    
    private var cancellables = Set<AnyCancellable>()
    
    private let calendar: Calendar
    private let deviceService: DeviceService
    
    init(
        calendar: Calendar = .current,
        deviceService: DeviceService = DeviceServiceImpl(device: .current, processInformation: .processInfo)
    ) {
        self.calendar = calendar
        self.deviceService = deviceService
        
        fetchDeviceInformation()
        fetchApplePencilSupport()
        fetchSupportsWirelessCharging()
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
                        architecture: $0.cpu.architecture.uppercased()
                    ),
                    thermalState: self.mapToThermalState($0.thermalState),
                    uptime: self.mapDateToUptime(Date(timeIntervalSince1970: $0.uptime)),
                    lastReboot: Date() - $0.uptime
                )
            }
            .sink { [unowned self] in
                deviceInformation = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchApplePencilSupport() {
        deviceService
            .applePencilSupport()
            .map { self.mapToApplePencilSupport($0) }
            .sink { [unowned self] in
                applePencilSupport = $0
            }
            .store(in: &cancellables)
    }
    
    private func fetchSupportsWirelessCharging() {
        deviceService
            .supportsWirelessCharging()
            .map { self.mapToSupport($0) }
            .sink { [unowned self] in
                supportsWirelessCharging = $0
            }
            .store(in: &cancellables)
    }
    
}

extension DeviceViewModel {
    
    private func mapToApplePencilSupport(_ support: DataLayer.ApplePencilSupport) -> DomainLayer.ApplePencilSupport {
        switch support {
        case .firstGen:
            return DomainLayer.ApplePencilSupport.firstGen
        case .secondGen:
            return DomainLayer.ApplePencilSupport.secondGen
        case .none:
            return DomainLayer.ApplePencilSupport.none
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
    
    private func mapDateToUptime(_ date: Date) -> String {
        let time = calendar.dateComponents([.day, .hour, .minute, .second], from: date)
        
        return "\(time.day ?? 0)d \(time.hour ?? 0)h \(time.minute ?? 0)m"
    }
    
}
