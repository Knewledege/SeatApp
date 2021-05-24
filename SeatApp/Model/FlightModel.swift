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
    func updateCustomer()
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
    internal var customerName:[[String]] = []
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
    func getFlightNameByID(id: Int) {
        if let result = self.sqLite?.fetchFlightName(id: id){
            self.flightInfo.append(result)
        }
    }
    func getFlightInfo() {
        if let result = self.sqLite?.fetchFlightInfo(){
            self.flightInfo = result
        }
    }
    func getFlightCustomer(id: Int) {
        if let result = self.sqLite?.fetchFlightCustomer(id: id){
            self.customers = result
            self.changeCustomers = self.customers
        }
    }
    func getFlightConfigurationByID(id: Int) {
        if let result = self.sqLite?.fetchConfigurationInfo(id: id){
            self.configurationInfo = result
        }
    }
    func getSeatNumber(id: Int) {
        if let result = self.sqLite?.fetchFlightSeatNumber(id: id){
            self.seatNumber = result
        }
    }
    func getCustomerImage(customer: Customer) -> String {
        var image:String = ""
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
        // 通路　行位置
        let rowsPass: [Int] = self.loInfo.filter{$0.type == "R"}.map{$0.row ?? 0}
        // 通路　列位置
        let columnsPass: [Int] = self.loInfo.filter{$0.type == "C"}.map{$0.column ?? 0}
        
        // 座席番号取得
        getSeatNumber(id: id)
        
        // topCell情報
        let topCell:[String] = [String](repeating: CommonImageResource.TOPCELL, count: columnSeats)
        // 行通路
        let pass: [String] = [String](repeating: "none", count: columnSeats)
        
        
        getFlightCustomer(id: id)
        var rowCount: Int = 1
        for i in 0...rowSeats {
            var rowData: [String] = self.seatNumber.filter { $0.row == i }.map { $0.seatNumber }
            var tempName: [String] = [String](repeating: "none", count: columnSeats)
            rowData.enumerated().forEach { index, number in
                if let customer = self.customers.filter { $0.seatNumber == number }.first {
                    tempName[index+1] = customer.name
                    rowData[index] = getCustomerImage(customer: customer)
                } else {
                    rowData[index] = CommonImageResource.SEAT
                }
            }
            if rowData.isEmpty {
                if i == 0 {
                    rowData.append(contentsOf: topCell)
                    for i in 1..<columnSeats { tempName[i] = String(i) }
                } else {
                    rowData = pass
                }
            } else {
                tempName[0] = String(rowCount)
                rowCount += 1
                rowData.insert(CommonImageResource.LEFTCELL, at: 0)
            }

            seatImage.append(rowData)
            customerName.append(tempName)
            
            columnsPass.forEach{
                seatImage[i].insert("none", at: $0+1)
                customerName[i].insert("none", at: $0+1)
            }
        }
        seatImage[0][0] = "none"
        customerName[0][0] = "none"
    }
    
    func getFlightLoInfo(id: Int) {
        if let result = self.sqLite?.fetchFlightLoInfo(id: id) {
            self.loInfo = result
        }
    }
    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath){
        self.seatImage[destinationIndexPath.section][destinationIndexPath.row] = self.seatImage[sourceIndexPath.section][sourceIndexPath.row]
        self.customerName[destinationIndexPath.section][destinationIndexPath.row] = self.customerName[sourceIndexPath.section][sourceIndexPath.row]
        self.seatImage[sourceIndexPath.section][sourceIndexPath.row ] = "seat"
        self.customerName[sourceIndexPath.section][sourceIndexPath.row] = "none"
        if let sourceSeat = self.seatNumber.filter { $0.row == sourceIndexPath.section && $0.column == sourceIndexPath.row }.first?.seatNumber,
           let destinationSeat = self.seatNumber.filter { $0.row == destinationIndexPath.section && $0.column == destinationIndexPath.row }.first?.seatNumber {
            if let customer = self.customers.filter { $0.seatNumber == sourceSeat }.first {
                self.changeCustomers[customer.id-1].seatNumber = destinationSeat
            }
        }
    }
    func updateCustomer(){
        self.sqLite?.insertCustomers(custmoers: changeCustomers)
    }
}
