//
//  Macro.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/16.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
/// 共通画像名
public enum CommonImageResource {

    static let TITLE: String = "座席編集アプリ"
    static let BOY: String = "boy"
    static let CANCELBTN: String = "cancel_btn"
    static let EDITBTN: String = "edit_btn"
    static let FEMALE: String = "female"
    static let GIRL: String = "girl"
    static let LEFTCELL: String = "left_cell"
    static let MALE: String = "male"
    static let OKBTN: String = "ok_btn"
    static let PULLDOWNBTN: String = "pulldown_btn"
    static let SEAT: String = "seat"
    static let TOPCELL: String = "top_cell"
    static let TOPEDITBTN: String = "top_edit_btn"
}
/// 便選択画面共通変数
public enum CommonFlightSelection {
    static let FLIGHTNAMESTITLE: String = "便名"
    static let FLIGHTDETAILSTITLE: String = "便情報"
    static let FLIGHTNAMEFIELDDEFAULT: String = "便名を選択してください"
}
/// 共通背景色
public enum CommonColor {
    static let MAINCOLOR: [Int] = [56, 164, 89]
}
/// 共通ログ出力クラス
public enum CommonLog {
    static func LOG(massege: String, file: String = #file, function: String = #function, line: Int = #line) {
        let now = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_hh_mm"
        let text = " \(file) [   \(function): \(format.string(from: now)) line =  \(line)] \(massege)\n"
        let fileName = "seatAppLog" + format.string(from: now) + ".txt"
        let filePath = NSHomeDirectory() + "/Documents/" + fileName
        if let file = FileHandle(forWritingAtPath: filePath) {
            print()
            if let contentData = text.data(using: .utf8) {
                file.seekToEndOfFile()
                file.write(contentData)
                file.closeFile()
            }
        } else {
            FileManager.default.createFile(
                atPath: filePath,
                contents: text.data(using: .utf8),
                attributes: nil
            )
        }
    }
}
/// 共通ログ出力メッセージ
public enum CommonLogMassege {
    static let PUSHPERFORMDISPLAYBUTTON: String = "座席表示画面ボタン押下"
    static let TRANSIOTIONFLIGHTSEATDISPLAY: String = "座席表示画面遷移"
    static let DIDNOTSELECTFLIGHTALERT: String = "フライト未選択"
    static let DIDSELECTPICKER: String = "フライト選択"
    static let CANCELSELECTPICKER: String = "フライト選択キャンセル"
    static let TRANSIOTIONSEATEDITDISPLAY: String = "座席編集画面遷移"
    static let BACKFLIGHTSELECTDISPLAY: String = "フライト選択画面戻る"
    static let DONEEDITBUTTON: String = "座席編集終了ボタン押下"
    static let SEATUPDATE: String = "座席情報更新"
    static let CANCELSEATEDITBUTTON: String = "座席編集キャンセルボタン押下"
    static let SEATEDITBUTTONCANCELALERT: String = "座席編集キャンセルアラート"
    static let SEATDRAGSTART: String = "座席ドラッグ開始"
    static let SEATDROP: String = "座席ドロップ"
}
