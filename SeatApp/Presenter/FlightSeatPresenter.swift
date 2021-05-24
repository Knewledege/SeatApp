//
//  FlightSeatPresenter.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/21.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
protocol FlightSeatInput {
    func getFlightName(id: Int)
    func getSeatColumn() -> Int
    func getSeatRow(id: Int) -> Int
    func getSeatNumber(section: Int, row: Int) -> String
    func getSeatName(section: Int, row: Int) -> String 
}
protocol FlightSeatOutput: AnyObject {
    func setLeftBarButtonItem(title: String)
}
class FlightSeatPresenter {
    private weak var delegate: FlightSeatOutput?
    private var model: FlightInput?
    init(delegate: FlightSeatOutput) {
        self.delegate = delegate
    }
}
extension FlightSeatPresenter: FlightSeatInput {
    func getFlightName(id: Int){
        self.model = FlightModel()
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
