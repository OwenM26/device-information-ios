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
    }
    
    public struct Display {
        public let zoomed: Bool
        public let diagonal: Double
        public let roundedCorners: Bool
        public let ppi: Int
        public let has3dTouch: Bool
    }
    
    public struct Camera {
        public let lidarSensor: Bool
        public let telephoto: Bool
        public let wide: Bool
        public let ultraWide: Bool
        public let torch: Bool
    }
    
    public let applePencil: ApplePencilSupport
    public let wirelessCharging: Bool
    public let touchID: Bool
    public let faceID: Bool
    public let display: Display
    public let camera: Camera
}
