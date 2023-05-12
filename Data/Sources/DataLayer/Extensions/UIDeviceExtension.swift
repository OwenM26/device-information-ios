//
//  UIDeviceExtension.swift
//  
//
//  Created by Owen Moore on 02/05/2023.
//

import UIKit

extension UIDevice {
    
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }

    var totalDiskSpaceInGB: String {
       ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: .decimal)
    }
    
    var freeDiskSpaceInGB: String {
        ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: .decimal)
    }
    
    var usedDiskSpaceInGB: String {
        ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: .decimal)
    }
    
    var totalDiskSpaceInMB: String {
        MBFormatter(totalDiskSpaceInBytes)
    }
    
    var freeDiskSpaceInMB: String {
        MBFormatter(freeDiskSpaceInBytes)
    }
    
    var usedDiskSpaceInMB: String {
        MBFormatter(usedDiskSpaceInBytes)
    }
    
    var totalDiskSpaceInBytes: Int64 {
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
        else {
            return 0
        }
        return space
    }
    
    var freeDiskSpaceInBytes: Int64 {
        if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
            return space
        } else {
            return 0
        }
    }
    
    var usedDiskSpaceInBytes: Int64 {
       totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }

}
