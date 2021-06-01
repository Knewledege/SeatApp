//
//  FlightModel.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/20.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
protocol FlightInput {
    func getFlightInfo()
    func getFlightCustomer(id: Int)
    func getFlightNameByID(id: Int)
    func getFlightConfigurationByID(id: Int)
    func getFlightSeatArray(id: Int)
    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    func updateCustomer() -> Bool

    var flightInfo: [FlightInfo] { get }
    var customerCount: Int { get }
    var configurationInfo: ConfigurationInfo? { get }
    var seatImage: [[String]] { get }
    var customerName: [[String]] { get }
}
class FlightModel {
    internal var flightInfo: [FlightInfo] = []
    internal var configurationInfo: ConfigurationInfo?
    internal var customers: [Customer] = []
    private var changeCustomers: [Customer] = []
    private var seatNumber: [SeatNumber] = []
    private var loInfo: [LoInfo] = []
    internal var seatImage: [[String]] = []
    internal var customerName: [[String]] = []
    internal var customerCount: Int {
        customers.count
    }
    private let sqLite: SQLite?

    init(sqLite: SQLite = SQLite()) {
        self.sqLite = sqLite
    }
    deinit {
        print("Model deinit")
    }
}
extension FlightModel: FlightInput {
    /// 便名取得
    func getFlightNameByID(id: Int) {
        if let result = self.sqLite?.fetchFlightName(id: id) {
            self.flightInfo.append(result)
        }
    }
    /// 座席情報テーブル取得
    func getFlightInfo() {
        if let result = self.sqLite?.fetchFlightInfo() {
            self.flightInfo = result
        }
    }
    /// 顧客情報テーブル取得
    func getFlightCustomer(id: Int) {
        if let result = self.sqLite?.fetchFlightCustomer(id: id) {
            self.customers = result
            self.changeCustomers = self.customers
        }
    }
    func getFlightConfigurationByID(id: Int) {
        if let result = self.sqLite?.fetchConfigurationInfo(id: id) {
            self.configurationInfo = result
        }
    }
    func getSeatNumber(id: Int) {
        if let result = self.sqLite?.fetchFlightSeatNumber(id: id) {
            self.seatNumber = result
        }
    }
    func getCustomerImage(customer: Customer) -> String {
        var image: String = ""
        if customer.gender == "M" && customer.age <= 18 { image = CommonImageResource.BOY }
        if customer.gender == "M" && customer.age > 18 { image = CommonImageResource.MALE }
        if customer.gender == "F" && customer.age <= 18 { image = CommonImageResource.GIRL }
        if customer.gender == "F" && customer.age > 18 { image = CommonImageResource.FEMALE }
        return image
    }
    func getFlightSeatArray(id: Int) {
        // 列数
        guard let columnSeats = self.configurationInfo?.columnSeats else {
            return
        }
        // 行数
        let rowSeats = self.configurationInfo?.rowSeats ?? 0
        // 通路情報取得
        getFlightLoInfo(id: id)
        // 通路　列位置
        let columnsPass: [Int] = self.loInfo.filter { $0.type == "C" }.map { $0.column ?? 0 }
        // 座席番号取得
        getSeatNumber(id: id)
        // topCell情報
        let topCell = [String](repeating: CommonImageResource.TOPCELL, count: columnSeats)
        // 行通路
        let pass: [String] = [String](repeating: "none", count: columnSeats)
        // 顧客情報取得
        getFlightCustomer(id: id)
        // 行番号
        var rowCount: Int = 1
        // 行数分ループ　通路も含めて
        for i in 0...rowSeats {
            // i 行の座席番号
            var rowData: [String] = self.seatNumber.filter { $0.row == i }.map { $0.seatNumber }
            // 仮顧客名　列数分
            var tempCustomerName: [String] = [String](repeating: "none", count: columnSeats)
            rowData.enumerated().forEach { index, number in
                // 顧客内に　i行の座席と同じ座席番号を持っている人を検索
                if let customer = self.customers.first(where: { $0.seatNumber == number }) {
                    // 仮顧客名に顧客名を設定
                    tempCustomerName[index + 1] = customer.name
                    // 座席画像設定
                    rowData[index] = getCustomerImage(customer: customer)
                } else {
                // 顧客が検索できなかった場合
                // "seat.png"を設定
                    rowData[index] = CommonImageResource.SEAT
                }
            }
            // i 行の座席番号が存在しない場合
            if rowData.isEmpty {
                // 先頭行
                if i == 0 {
                    rowData.append(contentsOf: topCell)
                    for i in 1..<columnSeats { tempCustomerName[i] = String(i) }
                // 廊下行
                } else {
                    rowData = pass
                }
            } else {
            // i 行の座席番号が存在する場合
                // 座席行番号
                tempCustomerName[0] = String(rowCount)
                rowCount += 1
                // 座席行表示欄　分の要素追加
                rowData.insert(CommonImageResource.LEFTCELL, at: 0)
            }
            // i行の座席画像追加
            seatImage.append(rowData)
            // i行の顧客名追加
            customerName.append(tempCustomerName)
            // i行の廊下　列追加
            columnsPass.forEach {
                seatImage[i].insert("none", at: $0 + 1)
                customerName[i].insert("none", at: $0 + 1)
            }
        }
        // 一番左上は画像と顧客名どちらも"none"
        seatImage[0][0] = "none"
        customerName[0][0] = "none"
    }

    func getFlightLoInfo(id: Int) {
        if let result = self.sqLite?.fetchFlightLoInfo(id: id) {
            self.loInfo = result
        }
    }
    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        // 移動先座席の画像名に移動元座席の画像名を設定
        self.seatImage[destinationIndexPath.section][destinationIndexPath.row] = self.seatImage[sourceIndexPath.section][sourceIndexPath.row]
        // 移動先座席の顧客名に移動元座席の顧客名を設定
        self.customerName[destinationIndexPath.section][destinationIndexPath.row] = self.customerName[sourceIndexPath.section][sourceIndexPath.row]
        // 移動元の画像名と座席名を空席設定
        self.seatImage[sourceIndexPath.section][sourceIndexPath.row ] = "seat"
        self.customerName[sourceIndexPath.section][sourceIndexPath.row] = "none"
        // 移動元及び移動先の座席番号取得
        if let sourceSeat = self.seatNumber.first(where: { $0.row == sourceIndexPath.section && $0.column == sourceIndexPath.row })?.seatNumber,
            let destinationSeat = self.seatNumber.first(where: { $0.row == destinationIndexPath.section && $0.column == destinationIndexPath.row })?.seatNumber {
            self.customers.enumerated().forEach { i, value in
                // 移動元の座席番号と同じ顧客を特定
                if value.seatNumber == sourceSeat {
                    // 移動先の座席番号を設定
                    self.changeCustomers[i].seatNumber = destinationSeat
                }
            }
        }
    }
    func updateCustomer() -> Bool {
        self.sqLite?.insertCustomers(custmoers: changeCustomers) ?? false
    }
}
