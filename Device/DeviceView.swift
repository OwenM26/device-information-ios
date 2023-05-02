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
                displayView
                cameraView
                motionView
                peripheralsView
            }
            .navigationTitle("My Device")
            .refreshable {
                viewModel.fetchData()
            }
        }
    }
    
    @ViewBuilder
    var deviceDetailsView: some View {
        Section("Device") {
            if let modelName = viewModel.deviceInformation?.name {
                LabeledContent("Model Name", value: modelName)
            }
            
            if let deviceInformation = viewModel.deviceInformation {
                LabeledContent("OS", value: deviceInformation.os)
                LabeledContent("Temperature", value: deviceInformation.thermalState.localisedString)
                generateSupportView(
                    title: "Jailbroken",
                    systemImageName: deviceInformation.isJailbroken.systemImageName
                )
                generateSupportView(
                    title: "Multitasking",
                    systemImageName: deviceInformation.multitasking.systemImageName
                )
                LabeledContent("Uptime", value: deviceInformation.uptime)
                LabeledContent("Last Reboot", value: deviceInformation.lastReboot, format: .dateTime)
            }
        }
        
        Section("CPU") {
            if let deviceInformation = viewModel.deviceInformation {
                LabeledContent("Processor", value: deviceInformation.cpu.processor)
                LabeledContent("Architecture", value: deviceInformation.cpu.architecture)
                LabeledContent("Total Cores", value: String(deviceInformation.cpu.cores))
                LabeledContent("Active Cores", value: String(deviceInformation.cpu.activeCores))
            }
        }
    }
    
    @ViewBuilder
    var biometricsView: some View {
        Section("Biometrics") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    title: "Touch ID",
                    systemImageName: deviceInformation.touchID.systemImageName
                )
                
                generateSupportView(
                    title: "Face ID",
                    systemImageName: deviceInformation.faceID.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var batteryView: some View {
        Section("Battery") {
            if let batteryLevel = viewModel.batteryLevel {
                LabeledContent("Level", value: batteryLevel)
            }
            
            if let batteryState = viewModel.batteryState {
                LabeledContent("State", value: batteryState.localisedString)
            }
            
            if let lowPowerMode = viewModel.batteryLowPowerMode {
                LabeledContent("Low Power Mode", value: lowPowerMode.localisedString)
            }
            
            if let deviceSupport = viewModel.deviceSupport {
                generateSupportView(
                    title: "Wireless Charging",
                    systemImageName: deviceSupport.wirelessCharging.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var displayView: some View {
        Section("Display") {
            if let deviceSupport = viewModel.deviceSupport {
                LabeledContent("Diagonal", value: deviceSupport.display.diagonal)
                LabeledContent("Pixel Density", value: deviceSupport.display.ppi)
                LabeledContent("Pixel Resolution", value: deviceSupport.display.resolution.formatted)
                
                generateSupportView(
                    title: "Zoom",
                    systemImageName: deviceSupport.display.zoomed.systemImageName
                )
                
                generateSupportView(
                    title: "Rounded Corners",
                    systemImageName: deviceSupport.display.roundedCorners.systemImageName
                )
                
                generateSupportView(
                    title: "3D Touch",
                    systemImageName: deviceSupport.display.has3dTouch.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var cameraView: some View {
        Section("Camera") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    title: "Telephoto Sensor",
                    systemImageName: deviceInformation.camera.telephoto.systemImageName
                )
                
                generateSupportView(
                    title: "Lidar Sensor",
                    systemImageName: deviceInformation.camera.lidarSensor.systemImageName
                )
                
                generateSupportView(
                    title: "Wide Sensor",
                    systemImageName: deviceInformation.camera.wide.systemImageName
                )
                
                generateSupportView(
                    title: "UltraWide Sensor",
                    systemImageName: deviceInformation.camera.ultraWide.systemImageName
                )
                
                generateSupportView(
                    title: "Torch",
                    systemImageName: deviceInformation.camera.torch.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var motionView: some View {
        Section("Motion") {
            if let deviceInformation = viewModel.deviceSupport {
                generateSupportView(
                    title: "Step Counting",
                    systemImageName: deviceInformation.counting.steps.systemImageName
                )
                
                generateSupportView(
                    title: "Cadence Counting",
                    systemImageName: deviceInformation.counting.cadence.systemImageName
                )
                
                generateSupportView(
                    title: "Floor Counting",
                    systemImageName: deviceInformation.counting.floors.systemImageName
                )
                
                generateSupportView(
                    title: "Pace Monitoring",
                    systemImageName: deviceInformation.counting.pace.systemImageName
                )
                
                generateSupportView(
                    title: "Distance Monitoring",
                    systemImageName: deviceInformation.counting.distance.systemImageName
                )
            }
        }
    }
    
    @ViewBuilder
    var peripheralsView: some View {
        Section("Peripherals") {
            if let deviceInformation = viewModel.deviceSupport {
                LabeledContent("Apple Pencil", value: deviceInformation.applePencil.localisedTitle)
            }
        }
    }
    
    @ViewBuilder
    private func generateSupportView(
        title: String,
        systemImageName: String
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: systemImageName)
        }
    }
}
