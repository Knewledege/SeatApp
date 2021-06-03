//
//  FlightItemNumberCollectionViewCell.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/23.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class FlightItemNumberCollectionViewCell: UICollectionViewCell {
    static let className: String = "FlightItemNumberCollectionViewCell"
    // 座席行・列画像
    @IBOutlet private weak var contentImage: UIImageView!
    // 座席行・列数ラベル
    @IBOutlet private weak var numberLabel: UILabel!
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
           numberLabel.text = nil
    }
    /// 座席行・列背景画像設定
    internal func imageConfigure(type: CellType) {
        // noneは空席もしくは廊下のため未設定
        switch type {
        case .passCell:
            break
        default:
            contentImage.imageConfigure(name: type.imageName)
        }
    }
    /// 背景色
    internal func cellBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    /// 座席行数ラベル設定
    internal func rowLabelConfigure(text: String) {
        // noneは廊下のため未設定
        if text != Common.NOCUTMERNAME {
            numberLabel.text = text
        }
    }
    /// 座席列数ラベル設定
    internal func columnLabelConfigure(text: String) {
        // noneは廊下のため未設定
        if text != Common.NOCUTMERNAME {
            numberLabel.text = CommonColumnEng.COLUMNENG[text]
        }
    }
}
