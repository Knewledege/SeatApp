//
//  UIStackViewExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/16.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIStackView {
    func stackViewConfigure(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
    }
}
