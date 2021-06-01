//
//  Entity.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/18.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
import GRDB
struct FlightInfo: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var flightID: Int
    var seats: Int
    var flightName: String
    static var databaseTableName: String {
        "FL_INFO"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case flightID
        case seats
        case flightName
    }
}
struct ConfigurationInfo: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationInfoID: Int
    var flightInfoID: Int
    var rowSeats: Int
    var columnSeats: Int
    static var databaseTableName: String {
        "CONF_INFO"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case configurationInfoID
        case flightInfoID
        case rowSeats
        case columnSeats
    }
}
struct LoInfo: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationID: Int
    var type: String
    var row: Int?
    var column: Int?
    static var databaseTableName: String {
        "LO_INFO"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case configurationID
        case type
        case row
        case column
    }
}
struct SeatNumber: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationID: Int
    var seatNumber: String
    var row: Int
    var column: Int
    static var databaseTableName: String {
        "SEAT_NO"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case configurationID
        case seatNumber
        case row
        case column
    }
}
struct Customer: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var flightID: Int
    var seatNumber: String
    var gender: String
    var age: Int
    var name: String
    static var databaseTableName: String {
        "CUSTOMER"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case flightID
        case seatNumber
        case gender
        case age
        case name
    }
}
