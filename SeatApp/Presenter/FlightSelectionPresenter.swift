//
//  FlightSelectionPresenter.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
public protocol FlightSelectionInput {
    func setFlightInfo()
    func setFlightName(row: Int) -> String
    func setFlightDetails(id: Int)
    func setFlightCount() -> Int
}
public protocol FlightSelectionOutput: AnyObject {
    func setTextView(text: String)
}
internal class FlightSelectionPresenter {
    private weak var delegate: FlightSelectionOutput?
    private var model: FlightInput?
    init(delegate: FlightSelectionOutput) {
        self.delegate = delegate
    }
    deinit {
    }
}
extension FlightSelectionPresenter: FlightSelectionInput {
    func setFlightInfo() {
        self.model = FlightModel()
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
        if let customers = self.model?.customerCount{
            let seats: Int = self.model?.flightInfo[id].seats ?? 0
            let seatsText = "座席数：" + String(seats) + "数"
            let customersText = "搭乗人数：" + String(customers) + "名"
            let infoText = seatsText + "\n" + customersText
            self.delegate?.setTextView(text: infoText)
        }
    }
}
