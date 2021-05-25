//
//  FlightSeatView.swift
//  SeatAppUITests
//
//  Created by 高橋慧 on 2021/05/25.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import XCTest
@testable import SeatApp
class FlightSeatViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testViewController() {
        
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0)
        let textField = element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        let popoversQuery = app.popovers
        popoversQuery.pickerWheels.firstMatch.press(forDuration: 1.0);
        let toolbar = popoversQuery.toolbars["Toolbar"]
        toolbar.buttons["OK"].tap()
        let topEditBtnButton = app.buttons["top edit btn"]
        topEditBtnButton.tap()
        
        let seatappFlightseatviewNavigationBar = app.navigationBars["SeatApp.FlightSeatView"]
        seatappFlightseatviewNavigationBar.buttons["便名：TEST_001"].tap()
        topEditBtnButton.tap()
        seatappFlightseatviewNavigationBar.buttons["edit btn"].tap()
        
    }
}
