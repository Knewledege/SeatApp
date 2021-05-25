//
//  FlightSelectionView.swift
//  SeatAppUITests
//
//  Created by 高橋慧 on 2021/05/25.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import XCTest
@testable import SeatApp
class FlightSelectionViewTests: XCTestCase {

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
    
    func testPopOverPresent() {
        let app = XCUIApplication()
        app.buttons["top edit btn"].tap()
        let alert =  app.alerts["便名を選択してください。"]
        let alertExists = alert.exists
        XCTAssert(alertExists)
        alert.buttons["OK"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0)
        let textField = element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        let popoversQuery = app.popovers
        let popoversExists = popoversQuery.pickers.element
        let pickerExists = popoversExists.exists
        XCTAssert(pickerExists)
        popoversQuery/*@START_MENU_TOKEN@*/.pickerWheels["TEST_001"]/*[[".pickers.pickerWheels[\"TEST_001\"]",".pickerWheels[\"TEST_001\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        
        let toolbar = popoversQuery.toolbars["Toolbar"]
        toolbar.buttons["OK"].tap()
        textField.tap()
        toolbar.buttons["キャンセル"].tap()
        textField.tap()
        
        let popoverdismissregionElement = app/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        popoverdismissregionElement.tap()
     }
}
