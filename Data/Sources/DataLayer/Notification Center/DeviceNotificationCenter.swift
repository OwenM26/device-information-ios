//
//  DeviceNotificationCenter.swift
//  
//
//  Created by Owen Moore on 01/06/2023.
//

import Combine
import Foundation

public protocol DeviceNotificationCenter {
    func publisher(for name: Notification.Name, object: AnyObject?) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure>
}

extension NotificationCenter: DeviceNotificationCenter {
    
    public func publisher(for name: Notification.Name, object: AnyObject?) -> AnyPublisher<Publisher.Output, Publisher.Failure> {
        publisher(for: name).eraseToAnyPublisher()
    }
    
}
