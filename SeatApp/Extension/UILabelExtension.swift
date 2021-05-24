//
//  UILabelExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/17.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UILabel {
    func labelConfigure(textAlignment: NSTextAlignment, size: CGFloat, weight: UIFont.Weight) {
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: size, weight: weight)
    }
    func setText(text: String, color: UIColor) {
        self.text = text
        self.textColor = color
    }
}
