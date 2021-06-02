//
//  SeatEditPresenter.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/21.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
protocol SeatEditInput {
    /// 便名取得
    func getFlightName(id: Int)
    /// 座席列数取得
    func getSeatColumn() -> Int
    /// 座席行数取得
    func getSeatRow(id: Int) -> Int
    /// セル画像名取得
    func getSeatNumber(section: Int, row: Int) -> String
    /// セル表示テキスト取得
    func getSeatName(section: Int, row: Int) -> String
    /// セル再設定
    func resetCellInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    /// 顧客情報更新
    func updateSeatData()
}
protocol SeatEditOutput: AnyObject {
    /// 便名表示　設定
    func setLeftBarButtonItem(title: String)
    /// 顧客情報テーブル更新結果表示
    func updateCustomerResultAlert(title: String)
}

class SeatEditPresenter {
    private weak var delegate: SeatEditOutput?
    private var model: FlightInput?

    init(delegate: SeatEditOutput) {
        self.delegate = delegate
    }
}
extension SeatEditPresenter: SeatEditInput {
    func getFlightName(id: Int) {
        self.model = FlightModel()
        // 便名取得
        self.model?.getFlightNameByID(id: id)
        // 座席情報テーブル取得
        self.model?.getFlightConfigurationByID(id: id)
        // 座席画像及び顧客名取得
        self.model?.getFlightSeatArray(id: id)
        // 便名表示に表示するタイトル指定
        if let flightName = self.model?.flightInfo.first?.flightName {
            let title = "便名：" + flightName
            self.delegate?.setLeftBarButtonItem(title: title)
        }
    }
    /// コレクションビューのセルの列数
    func getSeatColumn() -> Int {
        if let column = self.model?.configurationInfo?.columnSeats {
            // 座席行表示欄もあるためプラス１
            return column + 1
        }
        return 0
    }
    /// コレクションビューのセルの行数
    func getSeatRow(id: Int) -> Int {
        if let row = self.model?.configurationInfo?.rowSeats {
            // 座席列表示欄もあるためプラス１
            return row + 1
        }
        return 0
    }
    /// 座席表示欄の画像名取得
    func getSeatNumber(section: Int, row: Int) -> String {
        self.model?.seatImage[section][row] ?? "none"
    }
    /// 座席表示欄の顧客名取得
    func getSeatName(section: Int, row: Int) -> String {
        self.model?.customerName[section][row] ?? "none"
    }
    /// セルドロップ後のデータベース更新
    func resetCellInfo(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        self.model?.resetSeatInfo(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    /// セルドロップ後データベース更新結果取得
    func updateSeatData() {
        if let result = self.model?.updateCustomer() {
            var title: String = ""
            if result {
                title = "座席の編集が成功しました。"
            } else {
                title = "座席の編集が失敗しました。"
            }
            self.delegate?.updateCustomerResultAlert(title: title)
        }
    }
}
