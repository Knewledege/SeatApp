//
//  FlightSelectionPresenter.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
protocol FlightSelectionInput {
    /// 顧客情報取得
    func setFlightInfo()
    /// 便名取得
    func setFlightName(index: Int) -> String
    /// 機体情報取得
    func setFlightDetails(index: Int)
    /// 機体数取得
    func setFlightCount() -> Int
    /// 便ID取得
    func getFlightID(index: Int) -> Int
}
protocol FlightSelectionOutput: AnyObject {
    func setTextView(text: String)
}
internal class FlightSelectionPresenter {
    private weak var delegate: FlightSelectionOutput?
    private var model: FlightInput?

    init(delegate: FlightSelectionOutput) {
        self.delegate = delegate
        self.model = FlightModel()
    }
    deinit {
    }
}
extension FlightSelectionPresenter: FlightSelectionInput {
    /// 顧客情報取得
    func setFlightInfo() {
        self.model?.getFlightInfo()
    }
    /// 便名取得
    func setFlightName(index: Int) -> String {
        self.model?.flightInfo[index].flightName ?? ""
    }
    /// 機体数取得
    func setFlightCount() -> Int {
        self.model?.flightInfo.count ?? 0
    }
    /// 機体情報取得
    func setFlightDetails(index: Int) {
        let flightID = getFlightID(index: index)
        self.model?.getFlightCustomer(id: flightID)
        if let customers = self.model?.customerCount {
            let seats: Int = self.model?.flightInfo[index].seats ?? 0
            let seatsText = "座席数：" + String(seats) + "数"
            let customersText = "搭乗人数：" + String(customers) + "名"
            let infoText = seatsText + "\n" + customersText
            self.delegate?.setTextView(text: infoText)
        }
    }
    /// 便ID取得
    func getFlightID(index: Int) -> Int {
        self.model?.flightInfo[index].flightID ?? 0
    }
}
