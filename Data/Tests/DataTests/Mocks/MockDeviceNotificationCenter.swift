//
//  MockDeviceNotificationCenter.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import Combine
import Foundation
@testable import DataLayer

final class MockDeviceNotificationCenter: DeviceNotificationCenter {
    
    var postedNotificationName: NSNotification.Name?
    var postedObject: Any?
    var postedUserInfo: [AnyHashable: Any]?
    
    var name: Notification.Name?
    var object: AnyObject?
    let returnPublisher = PassthroughSubject<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure>()
    
    func publisher(for name: Notification.Name, object: AnyObject?) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        self.name = name
        self.object = object
        
        return returnPublisher.eraseToAnyPublisher()
    }
    
}
