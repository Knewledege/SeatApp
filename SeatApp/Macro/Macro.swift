//
//  Macro.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/16.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
public enum CommonImageResource {
    public static let TITLE: String = "座席編集アプリ"
    public static let BOY: String = "boy"
    public static let CANCELBTN: String = "cancel_btn"
    public static let EDITBTN: String = "edit_btn"
    public static let FEMALE: String = "female"
    public static let GIRL: String = "girl"
    public static let LEFTCELL: String = "left_cell"
    public static let MALE: String = "male"
    public static let OKBTN: String = "ok_btn"
    public static let PULLDOWNBTN: String = "pulldown_btn"
    public static let SEAT: String = "seat"
    public static let TOPCELL: String = "top_cell"
    public static let TOPEDITBTN: String = "top_edit_btn"
}
public enum CommonFlightSelection {
    public static let FLIGHTNAMESTITLE: String = "便名"
    public static let FLIGHTDETAILSTITLE: String = "便情報"
    public static let FLIGHTNAMEFIELDDEFAULT: String = "便名を選択してください"
}
public enum CommonColor {
    public static let MAINCOLOR: [Int] = [56, 164, 89]
}
public class CommonLog {
    static func LOG(file: String = #file, function: String = #function, line: Int = #line, massege: String){
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
        }else{
            FileManager.default.createFile(
                atPath: filePath,
                contents: text.data(using: .utf8),
                attributes: nil
            )
        }
    }
}
public enum CommonLomMassege {
    public static let PUSHPERFORMDISPLAYBUTTON: String = "座席表示画面ボタン押下"
    public static let TRANSIOTIONFLIGHTSEATDISPLAY: String = "座席表示画面遷移"
    public static let DIDNOTSELECTFLIGHTALERT: String = "フライト未選択"
    public static let DIDSELECTPICKER: String = "フライト選択"
    public static let CANCELSELECTPICKER: String = "フライト選択キャンセル"
    public static let TRANSIOTIONSEATEDITDISPLAY: String = "座席編集画面遷移"
    public static let BACKFLIGHTSELECTDISPLAY: String = "フライト選択画面戻る"
    public static let DONEEDITBUTTON: String = "座席編集終了ボタン押下"
    public static let SEATUPDATE: String = "座席情報更新"
    public static let CANCELSEATEDITBUTTON: String = "座席編集キャンセルボタン押下"
    public static let SEATEDITBUTTONCANCELALERT: String = "座席編集キャンセルアラート"
    public static let SEATDRAGSTART: String = "座席ドラッグ開始"
    public static let SEATDROP: String = "座席ドロップ"
}
