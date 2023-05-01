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
        List {
            deviceDetailsView
            biometricsView
            batteryView
            displayView
            cameraView
            peripheralsView
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
                LabeledContent("Uptime", value: deviceInformation.uptime)
                LabeledContent("Last Reboot", value: deviceInformation.lastReboot, format: .dateTime)
            }
        }
        
        Section("CPU") {
            if let deviceInformation = viewModel.deviceInformation {
                LabeledContent("Processor", value: deviceInformation.cpu.processor)
                LabeledContent("Architecture", value: deviceInformation.cpu.architecture)
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
                generateSupportView(
                    title: "Zoom",
                    systemImageName: deviceSupport.display.zoomed.systemImageName
                )
                
                LabeledContent("Diagonal", value: deviceSupport.display.diagonal)
                
                generateSupportView(
                    title: "Rounded Corners",
                    systemImageName: deviceSupport.display.roundedCorners.systemImageName
                )
                
                LabeledContent("Pixel Density", value: deviceSupport.display.ppi)
                
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
