//
//  UIViewExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/17.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIView {
    func constraintsActive(_ constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
