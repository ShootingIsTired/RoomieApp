//
//  RoomieAppUITests.swift
//  RoomieAppUITests
//
//  Created by Yuting Hsu on 2024/4/22.
//

import XCTest
import SwiftUI
final class RoomieAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let app = XCUIApplication()
        app.terminate()
    }
    

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let element = app.otherElements["card:SAD.RoomieApp:sceneID:SAD.RoomieApp-0E73988E-4FC7-4E0D-9D3A-E5926B5AF2FB"].scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element(boundBy: 0)
        element.tap()
        element.tap()
        element.tap()
        print(app.debugDescription)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                let app = XCUIApplication()
                app.launch()
                addTeardownBlock {
                    app.terminate()
                }
            }
        }
    }
    
}
