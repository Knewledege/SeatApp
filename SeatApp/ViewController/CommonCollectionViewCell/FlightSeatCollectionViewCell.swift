//
//  FlightSeatCollectionViewCell.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/19.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class FlightSeatCollectionViewCell: UICollectionViewCell {
    // 座席画像
    @IBOutlet private weak var contentImage: UIImageView!
    // 顧客名ラベル
    @IBOutlet private weak var rowLabel: UILabel!
    static let className = "FlightSeatCollectionViewCell"
    /// 初期化
    override func awakeFromNib() {
        super.awakeFromNib()
        contentImage.contentMode = .scaleAspectFit
    }
    /// セル再利用
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        contentImage.image = nil
        rowLabel.text = nil
    }
    /// 座席画像設定
    internal func imageConfigure(name: String) {
        // noneは空席もしくは廊下のため未設定
        if name != "none" {
            contentImage.imageConfigure(name: name)
        }
    }
    /// 背景色
    internal func cellBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    /// 顧客名ラベル設定
    internal func rowLabelConfigure(text: String) {
        // noneは空席もしくは廊下のため未設定
        if text != "none" {
            rowLabel.text = text
        }
    }
}
