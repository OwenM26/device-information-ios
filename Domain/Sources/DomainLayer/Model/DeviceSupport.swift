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
        
        public struct Resolution {
            public let x: Int
            public let y: Int
            
            public init(
                x: Int,
                y: Int
            ) {
                self.x = x
                self.y = y
            }
            
            public var formatted: String {
                "\(y) x \(x)"
            }
        }
        
        public let zoomed: Support
        public let diagonal: String
        public let roundedCorners: Support
        public let ppi: String
        public let has3dTouch: Support
        public let resolution: Resolution
        
        public init(
            zoomed: Support,
            diagonal: String,
            roundedCorners: Support,
            ppi: String,
            has3dTouch: Support,
            resolution: Resolution
        ) {
            self.zoomed = zoomed
            self.diagonal = diagonal
            self.roundedCorners = roundedCorners
            self.ppi = ppi
            self.has3dTouch = has3dTouch
            self.resolution = resolution
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
    
    public struct Counting {
        public let steps: Support
        public let pace: Support
        public let distance: Support
        public let floors: Support
        public let cadence: Support
        
        public init(
            steps: Support,
            pace: Support,
            distance: Support,
            floors: Support,
            cadence: Support
        ) {
            self.steps = steps
            self.pace = pace
            self.distance = distance
            self.floors = floors
            self.cadence = cadence
        }
    }
    
    public struct Disk {
        public let totalSpace: String
        public let usedSpace: String
        public let freeSpace: String
        public let totalSpaceRaw: Int64
        public let usedSpaceRaw: Int64
        public let freeSpaceRaw: Int64
        
        public init(
            totalSpace: String,
            usedSpace: String,
            freeSpace: String,
            totalSpaceRaw: Int64,
            usedSpaceRaw: Int64,
            freeSpaceRaw: Int64
        ) {
            self.totalSpace = totalSpace
            self.usedSpace = usedSpace
            self.freeSpace = freeSpace
            self.totalSpaceRaw = totalSpaceRaw
            self.usedSpaceRaw = usedSpaceRaw
            self.freeSpaceRaw = freeSpaceRaw
        }
        
        public var percentageUsedFormatted: String {
            let percentage = (Double(totalSpaceRaw) - Double(usedSpaceRaw)) / Double(totalSpaceRaw) * 100
            let rounded = 100 - (round(percentage * 100) / 100)
            return "\(rounded)% Used"
        }
    }
    
    public let applePencil: ApplePencilSupport
    public let wirelessCharging: Support
    public let touchID: Support
    public let faceID: Support
    public let display: Display
    public let camera: Camera
    public let counting: Counting
    public let disk: Disk
    
    public init(
        applePencil: ApplePencilSupport,
        wirelessCharging: Support,
        touchID: Support,
        faceID: Support,
        display: Display,
        camera: Camera,
        counting: Counting,
        disk: Disk
    ) {
        self.applePencil = applePencil
        self.wirelessCharging = wirelessCharging
        self.touchID = touchID
        self.faceID = faceID
        self.display = display
        self.camera = camera
        self.counting = counting
        self.disk = disk
    }
}
