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
    // ファイルマネージャー
    private let fileManager = FileManager.default
    // ファイル名
    private let fileName = "Thumbs"
    // ファイルパス
    private var filePath = ""
    // アクセスキュー
    private var queue: DatabaseQueue?

    init() {
//        print(filePath)
        self.createDatabase()
    }

    /// データベースファイル取込
    func dataBaseConfigure() {
        do {
            queue = try DatabaseQueue(path: filePath)
        } catch {
            print("ファイル読み込み失敗")
        }
    }

    /// データベース生成
    private func createDatabase() {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "db") else {
            return
        }
        filePath = path
        let exists = fileManager.fileExists(atPath: filePath)
        dataBaseConfigure()
        if !exists {
            queue = nil
        }
    }
    /// 顧客情報テーブル更新
    internal func insertCustomers(custmoers: [Customer]) -> Bool {
        var result = false
        queue?.inDatabase { db in
            custmoers.forEach { data in
                do {
                    try data.update(db)
                    result = true
                } catch {
                    result = false
                }
            }
        }
        return result
    }
    /// 機体情報テーブル id該当レコード取得
    internal func fetchFlightName(id: Int) -> FlightInfo? {
        var result: FlightInfo?
        queue?.inDatabase { db in
            do {
                result = try FlightInfo.fetchOne(db, sql: "SELECT * FROM FL_INFO WHERE flightID = ?", arguments: [id], adapter: nil)
            } catch {
                result = nil
            }
        }
        return result
    }
    /// 機体情報テーブル 全レコード取得
    internal func fetchFlightInfo() -> [FlightInfo] {
        var result: [FlightInfo] = []
        do {
            try queue?.inDatabase { db in
                result = try FlightInfo.fetchAll(db)
            }
        } catch {
            print(error)
        }
        return result
    }
    /// 顧客情報テーブル 便ID該当レコード取得
    internal func fetchFlightCustomer(id: Int) -> [Customer] {
        var result: [Customer] = []
        do {
            try queue?.inDatabase { db in
                result = try Customer.fetchAll(db, sql: "SELECT * FROM CUSTOMER WHERE flightID = ?", arguments: [id], adapter: nil)
            }
        } catch {
            print(error)
        }
        return result
    }
    /// 座席情報テーブル　id該当レコード取得
    internal func fetchConfigurationInfo(id: Int) -> ConfigurationInfo? {
        var result: ConfigurationInfo?
        do {
            try queue?.inDatabase { db in
                result = try ConfigurationInfo.fetchOne(db, sql: "SELECT * FROM CONF_INFO WHERE flightInfoID = ?", arguments: [id], adapter: nil)
            }
        } catch {
            print(error)
            return nil
        }
        return result
    }
    /// 座席番号テーブル 座席情報ID該当レコード取得
    internal func fetchFlightSeatNumber(id: Int) -> [SeatNumber] {
        var result: [SeatNumber] = []
        do {
            try queue?.inDatabase { db in
                result = try SeatNumber.fetchAll(db, sql: "SELECT * FROM SEAT_NO WHERE configurationID = ?", arguments: [id], adapter: nil)
            }
        } catch {
            print(error)
        }
        return result
    }
    /// 通路情報テーブル 座席情報ID該当レコード取得
    internal func fetchFlightLoInfo(id: Int) -> [LoInfo] {
        var result: [LoInfo] = []
        do {
            try queue?.inDatabase { db in
                result = try LoInfo.fetchAll(db, sql: "SELECT * FROM LO_INFO WHERE configurationID = ?", arguments: [id], adapter: nil)
            }
        } catch {
            print(error)
        }
        return result
    }
}
