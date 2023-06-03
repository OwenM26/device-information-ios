import Combine
import DeviceKit
import XCTest
@testable import DataLayer

final class DataServiceTest: XCTestCase {
    
    private var mockDevice: MockDevice!
    private var mockNotificationCenter: MockDeviceNotificationCenter!
    private var mockScreen: MockScreen!
    private var sut: DeviceService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDevice = MockDevice()
        mockNotificationCenter = MockDeviceNotificationCenter()
        mockScreen = MockScreen()
        sut = DeviceServiceImpl(
            uiDevice: .current,
            device: mockDevice,
            processInformation: .processInfo,
            notificationCenter: mockNotificationCenter,
            application: .shared,
            screen: mockScreen
        )
        cancellables = Set()
    }
    
    override func tearDown() {
        super.tearDown()
        mockDevice = nil
        mockNotificationCenter = nil
        mockScreen = nil
        sut = nil
        cancellables = nil
    }
    
    func testBatteryLevelPublisher_ReceivesUpdates() {
        let expectation = XCTestExpectation(description: "Should receive four values for the battery level: nil (initial value), 0, 50, 100")
        expectation.expectedFulfillmentCount = 3
        
        var receivedValues = [Int?]()

        sut
            .batteryLevel()
            .sink {
                receivedValues.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockDevice.batteryLevel = 0
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockDevice.batteryLevel = 50
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockDevice.batteryLevel = 100
        mockNotificationCenter.returnPublisher.send(.testNotification)

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(receivedValues, [nil, 0, 50, 100])
    }
    
    func testBatteryStatePublisher_ReceivesUpdates() {
        let expectation = XCTestExpectation(description: "Should receive three values for the battery state: none (initial value), discharging, charging, full")
        expectation.expectedFulfillmentCount = 3
        
        var receivedValues = [BatteryState]()

        sut
            .batteryState()
            .sink {
                receivedValues.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockDevice.batteryState = .unplugged(99)
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockDevice.batteryState = .charging(100)
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockDevice.batteryState = .full
        mockNotificationCenter.returnPublisher.send(.testNotification)

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(receivedValues, [.none, .unplugged, .charging, .full])
    }
    
    func testScreenBrightnessPublisher_ReceivesUpdates() {
        let expectation = XCTestExpectation(description: "Should receive three values for the screen brightness: 0, 50, 100")
        expectation.expectedFulfillmentCount = 3
        
        var receivedValues = [Int]()

        sut
            .screenBrightness()
            .dropFirst()
            .sink {
                receivedValues.append($0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockScreen.screenBrightness = 0
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockScreen.screenBrightness = 50
        mockNotificationCenter.returnPublisher.send(.testNotification)
        
        mockScreen.screenBrightness = 100
        mockNotificationCenter.returnPublisher.send(.testNotification)

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(receivedValues, [0, 50, 100])
    }
    
}

extension Notification {
    fileprivate static let testNotification = Notification(name: .init(rawValue: "testNotification"))
}
