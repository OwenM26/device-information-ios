//
//  DeviceSupport.swift
//  
//
//  Created by Owen Moore on 01/05/2023.
//

import Foundation

public struct DeviceSupport {
    
    public enum ApplePencilSupport {
        case firstGen
        case secondGen
        case none
        
        public var localisedTitle: String {
            switch self {
            case .firstGen:
                return "First Generation Supported"
            case .secondGen:
                return "First Generation Supported"
            case .none:
                return "Not Supported"
            }
        }
    }
    
    public struct Display {
        public let zoomed: Support
        public let diagonal: String
        public let roundedCorners: Support
        public let ppi: String
        public let has3dTouch: Support
        
        public init(
            zoomed: Support,
            diagonal: String,
            roundedCorners: Support,
            ppi: String,
            has3dTouch: Support
        ) {
            self.zoomed = zoomed
            self.diagonal = diagonal
            self.roundedCorners = roundedCorners
            self.ppi = ppi
            self.has3dTouch = has3dTouch
        }
    }
    
    public struct Camera {
        public let lidarSensor: Support
        public let telephoto: Support
        public let wide: Support
        public let ultraWide: Support
        public let torch: Support
        
        public init(
            lidarSensor: Support,
            telephoto: Support,
            wide: Support,
            ultraWide: Support,
            torch: Support
        ) {
            self.lidarSensor = lidarSensor
            self.telephoto = telephoto
            self.wide = wide
            self.ultraWide = ultraWide
            self.torch = torch
        }
    }
    
    public let applePencil: ApplePencilSupport
    public let wirelessCharging: Support
    public let touchID: Support
    public let faceID: Support
    public let display: Display
    public let camera: Camera
    
    public init(
        applePencil: ApplePencilSupport,
        wirelessCharging: Support,
        touchID: Support,
        faceID: Support,
        display: Display,
        camera: Camera
    ) {
        self.applePencil = applePencil
        self.wirelessCharging = wirelessCharging
        self.touchID = touchID
        self.faceID = faceID
        self.display = display
        self.camera = camera
    }
}
