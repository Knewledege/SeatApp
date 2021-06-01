//
//  FlightSeatCollectionViewCell.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/19.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class FlightSeatCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var rowLabel: UILabel!
    static let className = "FlightSeatCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        contentImage.contentMode = .scaleAspectFit
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        contentImage.image = nil
        rowLabel.text = nil
    }

    internal func imageConfigure(name: String) {
        if name != "none" {
            contentImage.imageConfigure(name: name)
        }
    }

    internal func cellBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

    internal func rowLabelConfigure(text: String) {
        if text != "none" {
            rowLabel.text = text
        }
    }
}
