//
//  MockScreen.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import Foundation
@testable import DataLayer

final class MockScreen: MyScreen {

    init() { }
    
    var screenBrightness: Int = 0
    
    var scale: CGFloat {
        1
    }
    
    var bounds: CGRect {
        .zero
    }
    
}
