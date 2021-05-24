//
//  SQLite.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/18.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
import GRDB
class SQLite {
    private let fileManager = FileManager.default
    private let filePath = NSHomeDirectory() + "/Documents/" + "Thumbs.db"
    private var queue : DatabaseQueue?
    init() {
//        print(filePath)
        self.createDatabase()
    }

    /// データベースファイル取込
    func dataBaseConfigure(){
        do {
            queue = try DatabaseQueue(path: filePath)
        } catch {
            print("ファイル読み込み失敗")
        }
    }

    /// データベース生成
    private func createDatabase() {
        let exists = fileManager.fileExists(atPath: filePath)
        dataBaseConfigure()
        if !exists {
            do{
                try queue?.inDatabase{ (db) in
                    try db.create(table: FlightInfo.databaseTableName) { (t) in
                        t.column(FlightInfo.CodingKeys.id.rawValue, .integer).primaryKey(onConflict: .ignore, autoincrement: true)
                        t.column(FlightInfo.CodingKeys.flightID.rawValue, .integer).notNull()
                        t.column(FlightInfo.CodingKeys.seats.rawValue, .integer).notNull()
                        t.column(FlightInfo.CodingKeys.flightName.rawValue, .text).notNull()
                    }
                    try db.create(table: ConfigurationInfo.databaseTableName) { (t) in
                        t.column(ConfigurationInfo.CodingKeys.id.rawValue, .integer).primaryKey(onConflict: .ignore, autoincrement: true)
                        t.column(ConfigurationInfo.CodingKeys.configurationInfoID.rawValue, .integer).notNull()
                        t.column(ConfigurationInfo.CodingKeys.flightInfoID.rawValue, .integer).notNull()
                        t.column(ConfigurationInfo.CodingKeys.rowSeats.rawValue, .integer).notNull()
                        t.column(ConfigurationInfo.CodingKeys.columnSeats.rawValue, .integer).notNull()
                    }
                    try db.create(table: LoInfo.databaseTableName) { (t) in
                        t.column(LoInfo.CodingKeys.id.rawValue, .integer).primaryKey(onConflict: .ignore, autoincrement: true)
                        t.column(LoInfo.CodingKeys.configurationID.rawValue, .integer).notNull()
                        t.column(LoInfo.CodingKeys.type.rawValue, .text).notNull()
                        t.column(LoInfo.CodingKeys.row.rawValue, .integer)
                        t.column(LoInfo.CodingKeys.column.rawValue, .integer)
                    }
                    try db.create(table: SeatNumber.databaseTableName) { (t) in
                        t.column(SeatNumber.CodingKeys.id.rawValue, .integer).primaryKey(onConflict: .ignore, autoincrement: true)
                        t.column(SeatNumber.CodingKeys.configurationID.rawValue, .integer).notNull()
                        t.column(SeatNumber.CodingKeys.seatNumber.rawValue, .text).notNull()
                        t.column(SeatNumber.CodingKeys.row.rawValue, .integer).notNull()
                        t.column(SeatNumber.CodingKeys.column.rawValue, .integer).notNull()
                    }
                    try db.create(table: Customer.databaseTableName) { (t) in
                        t.column(Customer.CodingKeys.id.rawValue, .integer).primaryKey(onConflict: .ignore, autoincrement: true)
                        t.column(Customer.CodingKeys.flightID.rawValue, .integer).notNull()
                        t.column(Customer.CodingKeys.seatNumber.rawValue, .integer).notNull()
                        t.column(Customer.CodingKeys.gender.rawValue, .text).notNull()
                        t.column(Customer.CodingKeys.age.rawValue, .integer).notNull()
                        t.column(Customer.CodingKeys.name.rawValue, .text).notNull()
                    }
                }
            } catch {
            }
        }
    }
    
    internal func insertCustomers(custmoers:[Customer]) {
        do{
            try queue?.inDatabase { (db) in
                custmoers.forEach{ data in
                    do{
                        try data.update(db)

                    }catch let error{
                        print(error)
                    }
                }
            }
        } catch {
        }
    }
    internal func fetchFlightName(id: Int) -> FlightInfo? {
        var result: FlightInfo?
        do{
            try queue?.inDatabase { (db) in
                result = try FlightInfo.fetchOne(db, key: id)
            }
        }catch let error{
            print(error)
            return nil
        }
        return result
    }
    internal func fetchFlightInfo() -> [FlightInfo]? {
        var result: [FlightInfo]?
        do{
            try queue?.inDatabase { (db) in
                result = try FlightInfo.fetchAll(db)
            }
        }catch let error{
            print(error)
            return nil
        }
        return result
    }
    internal func fetchFlightCustomer(id: Int) -> [Customer]? {
        var result: [Customer]?
        do{
            try queue?.inDatabase { (db) in
                result = try Customer.fetchAll(db, sql: "SELECT * FROM CUSTOMER WHERE flightID = ?", arguments: [id], adapter: nil)
            }
        }catch let error{
            print(error)
            return nil
        }
        return result
    }
    internal func fetchConfigurationInfo(id: Int) -> ConfigurationInfo? {
        var result: ConfigurationInfo?
        do{
            try queue?.inDatabase { (db) in
                result = try ConfigurationInfo.fetchOne(db, key: id)
            }
        } catch let error {
            print(error)
            return nil
        }
        return result
    }
    internal func fetchFlightSeatNumber(id: Int) -> [SeatNumber]? {
        var result: [SeatNumber]?
        do{
            try queue?.inDatabase { (db) in
                result = try SeatNumber.fetchAll(db, sql: "SELECT * FROM SEAT_NO WHERE configurationID = ?", arguments: [id], adapter: nil)
            }
        }catch let error{
            print(error)
            return nil
        }
        return result
    }
    internal func fetchFlightLoInfo(id: Int) -> [LoInfo]? {
        var result: [LoInfo]?
        do{
            try queue?.inDatabase { (db) in
                result = try LoInfo.fetchAll(db, sql: "SELECT * FROM LO_INFO WHERE configurationID = ?", arguments: [id], adapter: nil)
            }
        }catch let error{
            print(error)
            return nil
        }
        return result
    }
//    internal func getprefecturesByID(id: Int) -> Prefectures?{
//        var result: Prefectures?
//        do{
//            try queue?.inDatabase { (db) in
//                result = try Prefectures.fetchOne(db, key: id)
//            }
//        }catch let error{
//            print(error)
//            return nil
//        }
//        return result
//    }
}
