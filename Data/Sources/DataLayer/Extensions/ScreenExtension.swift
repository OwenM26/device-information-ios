//
//  ScreenExtension.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import UIKit

public protocol MyScreen {
    var screenBrightness: Int { get }
    var scale: CGFloat { get }
    var bounds: CGRect { get }
}

extension UIScreen: MyScreen {
    
    public var screenBrightness: Int {
        Int(brightness * 100)
    }
    
}
