//
//  FlightSelectionTests.swift
//  SeatAppTests
//
//  Created by 高橋慧 on 2021/05/25.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import XCTest
@testable import SeatApp
class FlightSelectionTests: XCTestCase {

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
    func testFlightSelection() {
        let mockViewController = MockFlightViewController()
        let presenter = MockFlightSelectionPresenter(delegate: mockViewController)

        presenter.setFlightInfo()

        mockViewController.flightName = presenter.setFlightName(row: 0)
        XCTAssertEqual(mockViewController.flightName, "testFlight001")

        mockViewController.flightCount = presenter.setFlightCount()
        XCTAssertEqual(mockViewController.flightCount, 2)

        presenter.setFlightDetails(id: 0)
        XCTAssertEqual(mockViewController.flightDetails, "座席数：10数\n搭乗人数：2名")
    }
}
class MockFlightViewController: FlightSelectionOutput {
    var flightName = ""
    var flightCount = 0
    var flightDetails = ""
    public func setTextView(text: String){ self.flightDetails = text }
}
class MockFlightSelectionPresenter: FlightSelectionInput {
    private weak var delegate: FlightSelectionOutput?
    private var model: FlightInput?
    init(delegate: FlightSelectionOutput) {
           self.delegate = delegate
           self.model = MockFlightModel()
    }
    func setFlightInfo() {
        self.model?.getFlightInfo()
    }
    func setFlightName(row: Int) -> String{
        return self.model?.flightInfo[row].flightName ?? ""
    }
    func setFlightCount() -> Int{
        return self.model?.flightInfo.count ?? 0
    }
    func setFlightDetails(id: Int){
        self.model?.getFlightCustomer(id: id + 1)
        
        if let customers = self.model?.customerCount {
            let seats: Int = self.model?.flightInfo[id].seats ?? 0
            let seatsText = "座席数：" + String(seats) + "数"
            let customersText = "搭乗人数：" + String(customers) + "名"
            let infoText = seatsText + "\n" + customersText
            self.delegate?.setTextView(text: infoText)
        }
    }
}

class MockFlightModel: FlightInput {

    var flightInfo: [FlightInfo] = []
    var customerCount: Int = 0
    var configurationInfo: ConfigurationInfo?
    var seatImage: [[String]] = []
    var customerName: [[String]] = []
    var loInfo: [LoInfo] = []
    var seatNumber: [SeatNumber] = []

    func getFlightInfo() {
        flightInfo = [
            FlightInfo(id: 1, flightID: 1, seats: 10, flightName: "testFlight001"),
            FlightInfo(id: 2, flightID: 2, seats: 20, flightName: "testFlight002")
        ]
    }

    func getFlightCustomer(id: Int) {
        customerCount = [
            Customer(id: 1, flightID: 1, seatNumber: "testSeat1", gender: "testM", age: 1, name: "testCustomer001"),
            Customer(id: 2, flightID: 2, seatNumber: "testSeat2", gender: "testF", age: 2, name: "testCustomer002")
        ].count
    }

    func getFlightNameByID(id: Int) {
        self.flightInfo.append(
            FlightInfo(id: 1, flightID: 1, seats: 10, flightName: "testFlight001")
        )
    }

    func getFlightConfigurationByID(id: Int) {
        self.configurationInfo = ConfigurationInfo(id: 1, configurationInfoID: 1, flightInfoID: 1, rowSeats: 5, columnSeats: 4)
    }
    func getFlightLoInfo(id: Int) {
        self.loInfo = [
            LoInfo(id: 1, configurationID: 1, type: "R", row: 2, column: nil),
            LoInfo(id: 2, configurationID: 1, type: "C", row: nil, column: 2)
        ]
    }
    func getFlightSeatArray(id: Int) {
    }

    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        print(#function)
    }

    func updateCustomer() -> Bool {
        print(#function)
        return true
    }
    
}
