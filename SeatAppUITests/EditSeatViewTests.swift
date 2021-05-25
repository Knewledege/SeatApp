//
//  EsitSeatViewTests.swift
//  SeatAppUITests
//
//  Created by 高橋慧 on 2021/05/25.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import XCTest

class EditSeatViewTests: XCTestCase {

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
    func testEditSeatDropDrag(){
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
        seatappFlightseatviewNavigationBar.buttons["edit btn"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 6).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).staticTexts["2"].tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 8).children(matching: .other).element.tap()
        
        let cellsQuery = collectionViewsQuery.cells
        let customer0001Element = cellsQuery.otherElements.containing(.staticText, identifier:"customer0001").element
                customer0001Element.tap()
        customer0001Element.swipeLeft()
        customer0001Element.swipeLeft()
        customer0001Element.swipeLeft()
        cellsQuery.otherElements.containing(.staticText, identifier:"customer0003").element.swipeRight()
        cellsQuery.otherElements.containing(.staticText, identifier:"customer0004").element.swipeLeft()
        cellsQuery.otherElements.containing(.staticText, identifier:"customer0009").element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        customer0001Element.swipeLeft()
        customer0001Element.tap()
        customer0001Element.swipeRight()
        customer0001Element.swipeRight()
        customer0001Element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        customer0001Element.swipeDown()
        customer0001Element.swipeLeft()
        
        let cancelBtnButton = app.navigationBars["SeatApp.SeatEditView"].buttons["cancel btn"]
        cancelBtnButton.tap()
        app.navigationBars["SeatApp.FlightSeatView"].buttons["edit btn"].tap()
        customer0001Element.tap()
        customer0001Element.swipeLeft()
        customer0001Element/*@START_MENU_TOKEN@*/.press(forDuration: 2.5);/*[[".tap()",".press(forDuration: 2.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        customer0001Element.press(forDuration: 1.6)
        cancelBtnButton.tap()
    }

}
