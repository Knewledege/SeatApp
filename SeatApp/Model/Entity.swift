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
        return "FL_INFO"
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case flightID = "flightID"
        case seats = "seats"
        case flightName = "flightName"
    }
}
struct ConfigurationInfo: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationInfoID: Int
    var flightInfoID: Int
    var rowSeats: Int
    var columnSeats: Int
    static var databaseTableName: String {
        return "CONF_INFO"
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case configurationInfoID = "configurationInfoID"
        case flightInfoID = "flightInfoID"
        case rowSeats = "rowSeats"
        case columnSeats = "columnSeats"
    }
}
struct LoInfo: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationID: Int
    var type: String
    var row: Int?
    var column: Int?
    static var databaseTableName: String {
        return "LO_INFO"
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case configurationID = "configurationID"
        case type = "type"
        case row = "row"
        case column = "column"
    }
}
struct SeatNumber: Codable, FetchableRecord, PersistableRecord {
    var id: Int
    var configurationID: Int
    var seatNumber: String
    var row: Int
    var column: Int
    static var databaseTableName: String {
        return "SEAT_NO"
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case configurationID = "configurationID"
        case seatNumber = "seatNumber"
        case row = "row"
        case column = "column"
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
        return "CUSTOMER"
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case flightID = "flightID"
        case seatNumber = "seatNumber"
        case gender = "gender"
        case age = "age"
        case name = "name"
    }
}
