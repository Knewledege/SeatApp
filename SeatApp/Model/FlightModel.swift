//
//  FlightModel.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/20.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
protocol FlightInput {
    /// 座席情報テーブル取得
    func getFlightInfo()
    /// 顧客情報テーブル取得
    func getFlightCustomer(id: Int)
    /// 便名取得
    func getFlightNameByID(id: Int)
    /// 座席情報テーブル取得
    func getFlightConfigurationByID(id: Int)
    /// セル表示画像・表示テキスト設定
    func getFlightSeatArray(id: Int)
    /// 座席再設定
    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    /// 顧客情報更新
    func updateCustomer() -> Bool
    /// 顧客情報編集有無判定
    func customerDataDidChangeResult() -> Bool

    var flightInfo: [FlightInfo] { get }
    var customerCount: Int { get }
    var configurationInfo: ConfigurationInfo? { get }
    var seatImage: [[CellType]] { get }
    var customerName: [[String]] { get }
}
class FlightModel {
    // 機体情報
    internal var flightInfo: [FlightInfo] = []
    // 座席情報
    internal var configurationInfo: ConfigurationInfo?
    // 顧客情報
    internal var customers: [Customer] = []
    // 更新顧客情報
    private var changeCustomers: [Customer] = []
    // 座席番号
    private var seatNumber: [SeatNumber] = []
    // 通路情報
    private var loInfo: [LoInfo] = []
    // 座席画像名
    internal var seatImage: [[CellType]] = []
    // 顧客名
    internal var customerName: [[String]] = []
    // 搭乗者数
    internal var customerCount: Int {
        customers.count
    }
    // SQL
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
    /// 座席情報テーブル取得
    func getFlightConfigurationByID(id: Int) {
        if let result = self.sqLite?.fetchConfigurationInfo(id: id) {
            self.configurationInfo = result
        }
    }
    /// 座席番号テーブル取得
    func getSeatNumber(id: Int) {
        if let result = self.sqLite?.fetchFlightSeatNumber(id: id) {
            self.seatNumber = result
        }
    }
    /// 座席表示欄　画像名設定
    func getCustomerImage(customer: Customer) -> CellType {
        // 男性且つ18才未満
        if customer.gender == "M" && customer.age <= 18 {
            return CellType.customerCell(.boy)
        }
        // 男性且つ19才以上
        if customer.gender == "M" && customer.age > 18 {
            return CellType.customerCell(.male)
        }
        // 女性且つ18才未満
        if customer.gender == "F" && customer.age <= 18 {
            return CellType.customerCell(.girl)
        }
        // 女性且つ19才以上
        if customer.gender == "F" && customer.age > 18 {
            return CellType.customerCell(.female)
        }
        return CellType.passCell
    }
    /// セル表示画像・表示テキスト設定
    /*
     ・i → 0 ~ 行数
     ・[0][i]の要素は、座席列表示欄用
     ・[i][0]の要素は、座席行表示欄用
     ・その他は、座席表示欄用
     　seatImage(画像名)：通路は"none"、空席は"seat"、顧客がいるセルはgetCustomerImageより取得
     　customerName(表示テキスト)：通路及び空席は"none"、顧客がいるセルはよりgetFlightCustomerで取得したself.customersの顧客名を取得
     */
    func getFlightSeatArray(id: Int) {
        self.seatImage = []
        self.customerName = []
        // テーブル：「座席情報」、カラム：「横」
        guard let columnSeats = self.configurationInfo?.columnSeats else {
            return
        }
        // テーブル：「座席情報」、カラム：「縦」
        let rowSeats = self.configurationInfo?.rowSeats ?? 0
        // 通路情報取得
        getFlightLoInfo(id: id)
        // 通路　列位置
        let columnsPass: [Int] = self.loInfo.filter { $0.type == "C" }.map { $0.column ?? 0 }
        // 座席番号取得
        getSeatNumber(id: id)
        // 顧客情報取得
        getFlightCustomer(id: id)
        // 行番号 座席行表示欄セルのラベルに表示用
        var rowCount: Int = 1
        // テーブル：「座席情報」、カラム：「縦」カラム分ループ
        for i in 0...rowSeats {
            // i 行の座席番号を全部取得
            var rowData: [String] = self.seatNumber.filter { $0.row == i }.map { $0.seatNumber }
            var tempSeatImage = [CellType](repeating: .passCell, count: rowData.count)
            // 仮顧客名 "none"で初期化。最終的には、顧客がいる席はcustomer.name　いない場合は空席のためそのまま
            // tempCustomerName[0] は座席行表示欄用
            var tempCustomerName: [String] = [String](repeating: Common.NOCUTMERNAME, count: columnSeats)
            // i行目の各座席の画像名及び表示テキストを仮設定
            rowData.enumerated().forEach { index, number in
                // i行のindex列目の座席に顧客がいるかを座席番号で検索
                if let customer = self.customers.first(where: { $0.seatNumber == number }) {
                    // 仮顧客名に顧客名を設定
                    // tempCustomerName[0] は座席行表示欄用のため +1
                    tempCustomerName[index + 1] = customer.name
                    // 座席画像設定
                    tempSeatImage[index] = getCustomerImage(customer: customer)
                } else {
                // 顧客が検索できなかった場合空席
                // "seat.png"を設定
                    rowData[index] = Common.SEAT
                    tempSeatImage[index] = CellType.seat
                }
            }
            // i 行の座席番号が存在しない場合は、座席列表示欄もしくは全部通路の行
            if rowData.isEmpty {
                // 座席列表示欄
                if i == 0 {
                    // 座席列表示欄画像名
                    let topCell = [CellType](repeating: .topCell, count: columnSeats)
                    tempSeatImage = topCell
                    for i in 1..<columnSeats { tempCustomerName[i] = String(i) }
                } else {
                // 通路の行
                    // 行通路　通路のため"none"で設定
                    let rowPass = [CellType](repeating: .passCell, count: columnSeats)
                    tempSeatImage = rowPass
                }
            } else {
            // i 行の座席番号が存在する場合
                // 座席行番号
                tempCustomerName[0] = String(rowCount)
                rowCount += 1
                // 座席行表示欄　分の要素追加
                tempSeatImage.insert(CellType.leftCell, at: 0)
            }
            // i行の座席画像追加
            seatImage.append(tempSeatImage)
            // i行の顧客名追加
            customerName.append(tempCustomerName)

            // 各列の通路追加
            // seatImage[0]及びcustomerName[0] は座席行表示欄用のため +1
            columnsPass.forEach {
                seatImage[i].insert(.passCell, at: $0 + 1)
                customerName[i].insert(Common.NOCUTMERNAME, at: $0 + 1)
            }
        }
        // 一番左上は画像と顧客名どちらも"none"
        seatImage[0][0] = .passCell
        customerName[0][0] = Common.NOCUTMERNAME
    }
    /// 通路情報テーブル取得
    func getFlightLoInfo(id: Int) {
        if let result = self.sqLite?.fetchFlightLoInfo(id: id) {
            self.loInfo = result
        }
    }
    /// 座席再設定
    func resetSeatInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        // 移動先座席の画像名に移動元座席の画像名を設定
        self.seatImage[destinationIndexPath.section][destinationIndexPath.row] = self.seatImage[sourceIndexPath.section][sourceIndexPath.row]
        // 移動先座席の顧客名に移動元座席の顧客名を設定
        self.customerName[destinationIndexPath.section][destinationIndexPath.row] = self.customerName[sourceIndexPath.section][sourceIndexPath.row]
        // 移動元の画像名と座席名を空席設定
        self.seatImage[sourceIndexPath.section][sourceIndexPath.row ] = .seat
        self.customerName[sourceIndexPath.section][sourceIndexPath.row] = Common.NOCUTMERNAME
        // 移動元及び移動先の座席番号取得
        if let sourceSeat = self.seatNumber.first(where: { $0.row == sourceIndexPath.section && $0.column == sourceIndexPath.row })?.seatNumber,
            let destinationSeat = self.seatNumber.first(where: { $0.row == destinationIndexPath.section && $0.column == destinationIndexPath.row })?.seatNumber {
            self.changeCustomers.enumerated().forEach { i, value in
                // 移動元の座席番号と同じ顧客を特定
                if value.seatNumber == sourceSeat {
                    // 移動先の座席番号を設定
                    self.changeCustomers[i].seatNumber = destinationSeat
                }
            }
        }
    }
    /// 顧客情報編集有無判定
    func customerDataDidChangeResult() -> Bool {
        let chengeCustomer = self.customers.indices.filter { index in
            /*
             customerは更新前 chengeCustomerは更新後
             等しく無い座席番号が存在したら編集済みとする
            */
            return customers[index].seatNumber != changeCustomers[index].seatNumber
        }
        print(chengeCustomer)
        if chengeCustomer.isEmpty {
            return false
        } else {
            return true
        }
    }
    /// 顧客情報更新
    func updateCustomer() -> Bool {
        self.sqLite?.insertCustomers(custmoers: changeCustomers) ?? false
    }
}
