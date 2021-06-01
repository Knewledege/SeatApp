//
//  FlightSeatTests.swift
//  SeatAppTests
//
//  Created by 高橋慧 on 2021/05/25.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import XCTest
@testable import SeatApp
class FlightSeatTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testFlightSeat() {
        let mockViewController = MockFlightSeatViewController()
        let presenter = MockFlightSeatPresenter(delegate: mockViewController)
    }
}
class MockFlightSeatViewController: FlightSeatOutput {
    var flightName = ""
    var flightCount = 0
    var flightDetails = ""
    var leftBarButtonTitle = ""
    func setLeftBarButtonItem(title: String) {
        self.leftBarButtonTitle = title
    }
}
class MockFlightSeatPresenter: FlightSeatInput {
    private weak var delegate: FlightSeatOutput?
    private var model: FlightInput?
    init(delegate: FlightSeatOutput) {
           self.delegate = delegate
           self.model = MockFlightModel()
    }
    func getFlightName(id: Int){
        self.model?.getFlightNameByID(id: id)
        self.model?.getFlightConfigurationByID(id: id)
        self.model?.getFlightSeatArray(id: id)
        if let flightName = self.model?.flightInfo.first?.flightName{
            let title = "便名：" + flightName
            self.delegate?.setLeftBarButtonItem(title: title)
        }
    }
    func getSeatColumn() -> Int{
        if let column = self.model?.configurationInfo?.columnSeats{
            return column + 1
        }
        return 0
    }
    func getSeatRow(id: Int) -> Int {
        if let row = self.model?.configurationInfo?.rowSeats{
            return row + 1
        }
        return 0
    }
    func getSeatNumber(section: Int, row: Int) -> String {
        return self.model?.seatImage[section][row] ?? "lo"
    }
    func getSeatName(section: Int, row: Int) -> String {
        return self.model?.customerName[section][row] ?? "none"
    }
}
