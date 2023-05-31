//
//  DeviceView.swift
//  Device
//
//  Created by Owen Moore on 01/05/2023.
//

import SwiftUI

struct DeviceView: View {
    
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        NavigationStack {
            List {
                deviceDetailsView
                biometricsView
                batteryView
                diskView
                displayView
                cameraView
                motionView
                peripheralsView
            }
            .navigationTitle("device.navigation.title")
            .refreshable {
                viewModel.fetchData()
            }
        }
    }
    
    @ViewBuilder
    var deviceDetailsView: some View {
        Section("device.section.device") {
            if let modelName = viewModel.deviceInformation?.name {
                LabeledContent("device.section.device.modelName", value: modelName)
            }
            
            if let deviceInformation = viewModel.deviceInformation {
                LabeledContent("device.section.device.os", value: deviceInformation.os)
                LabeledContent("device.section.device.temperature", value: deviceInformation.thermalState.localisedString)
                generateSupportView(
                    localisedStringKey: "device.section.device.jailbroken",
                    systemImageName: deviceInformation.isJailbroken.systemImageName
                )
                generateSupportView(
                    localisedStringKey: "device.section.device.multitasking",
                    systemImageName: deviceInformation.multitasking.systemImageName
                )
            }
        }
        
        Section("device.section.cpu") {
            if let deviceInformation = viewModel.deviceInformation {
                LabeledContent("device.section.cpu.processor", value: deviceInformation.cpu.processor)
                LabeledContent("device.section.cpu.architecture", value: deviceInformation.cpu.architecture.localisedString)
                LabeledContent("device.section.cpu.totalCores", value: String(deviceInformation.cpu.cores))
                LabeledContent("device.section.cpu.activeCores", value: String(deviceInformation.cpu.activeCores))
            }
        }
    }
    
    @ViewBuilder
    var biometricsView: some View {
        Section("device.section.biometrics") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    localisedStringKey: "device.section.biometrics.touchID",
                    systemImageName: deviceInformation.touchID.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.biometrics.faceID",
                    systemImageName: deviceInformation.faceID.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var batteryView: some View {
        Section("device.section.battery") {
            if let batteryLevel = viewModel.batteryLevel {
                LabeledContent("device.section.battery.level", value: batteryLevel)
            }
            
            if let batteryState = viewModel.batteryState {
                LabeledContent("device.section.battery.state", value: batteryState.localisedString)
            }
            
            if let lowPowerMode = viewModel.batteryLowPowerMode {
                LabeledContent("device.section.battery.lowPowerMode", value: lowPowerMode.localisedString)
            }
            
            if let deviceSupport = viewModel.deviceSupport {
                generateSupportView(
                    localisedStringKey: "device.section.battery.wirelessCharging",
                    systemImageName: deviceSupport.wirelessCharging.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var diskView: some View {
        Section("device.section.storage") {
            if let deviceInformation = viewModel.deviceSupport {
                ProgressView(value: Double(deviceInformation.disk.usedSpaceRaw), total: Double(deviceInformation.disk.totalSpaceRaw)) {
                    HStack {
                        Text(deviceInformation.disk.percentageUsedFormatted)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.bottom, 10)
                
                LabeledContent("device.section.storage.totalSpace", value: deviceInformation.disk.totalSpace)
                LabeledContent("device.section.storage.usedSpace", value: deviceInformation.disk.usedSpace)
                LabeledContent("device.section.storage.freeSpace", value: deviceInformation.disk.freeSpace)
            }
        }
    }
    
    @ViewBuilder
    var displayView: some View {
        Section("device.section.display") {
            if let deviceSupport = viewModel.deviceSupport {
                LabeledContent("device.section.display.brightness", value: viewModel.screenBrightness)
                LabeledContent("device.section.display.diagonal", value: deviceSupport.display.diagonal)
                LabeledContent("device.section.display.pixelDensity", value: deviceSupport.display.ppi)
                LabeledContent("device.section.display.pixelResolution", value: deviceSupport.display.resolution.formatted)
                
                generateSupportView(
                    localisedStringKey: "device.section.display.zoom",
                    systemImageName: deviceSupport.display.zoomed.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.display.roundedCorners",
                    systemImageName: deviceSupport.display.roundedCorners.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.display.forceTouch",
                    systemImageName: deviceSupport.display.has3dTouch.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var cameraView: some View {
        Section("device.section.camera") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    localisedStringKey: "device.section.camera.telephotoSensor",
                    systemImageName: deviceInformation.camera.telephoto.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.camera.lidarSensor",
                    systemImageName: deviceInformation.camera.lidarSensor.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.camera.wideSensor",
                    systemImageName: deviceInformation.camera.wide.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.camera.ultraWideSensor",
                    systemImageName: deviceInformation.camera.ultraWide.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.camera.torch",
                    systemImageName: deviceInformation.camera.torch.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var motionView: some View {
        Section("device.section.motion") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    localisedStringKey: "device.section.motion.stepCounting",
                    systemImageName: deviceInformation.counting.steps.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.motion.cadenceCounting",
                    systemImageName: deviceInformation.counting.cadence.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.motion.floorCounting",
                    systemImageName: deviceInformation.counting.floors.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.motion.paceMonitoring",
                    systemImageName: deviceInformation.counting.pace.systemImageName
                )
                
                generateSupportView(
                    localisedStringKey: "device.section.motion.distanceMonitoring",
                    systemImageName: deviceInformation.counting.distance.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var peripheralsView: some View {
        Section("device.section.peripherals") {
            if let deviceInformation = viewModel.deviceSupport {
                LabeledContent("device.section.peripherals.applePencil", value: deviceInformation.applePencil.localisedTitle)
            }
        }
    }
    
    @ViewBuilder
    private func generateSupportView(
        localisedStringKey: String,
        systemImageName: String
    ) -> some View {
        HStack {
            Text(LocalizedStringKey(localisedStringKey))
            Spacer()
            Image(systemName: systemImageName)
        }
    }
}
