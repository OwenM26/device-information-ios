//
//  DeviceView.swift
//  Device
//
//  Created by Owen Moore on 01/05/2023.
//

import SwiftUI

struct DeviceView: View {
    
    @ObservedObject private var viewModel = DeviceViewModel()
    
    var body: some View {
        List {
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
            
            Section("Support") {
                LabeledContent("Apple Pencil", value: viewModel.applePencilSupport.localisedTitle)
                
                generateSupportView(
                    title: "Wireless Charging",
                    systemImageName: viewModel.supportsWirelessCharging.systemImageName
                )
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

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
