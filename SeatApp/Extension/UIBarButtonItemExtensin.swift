//
//  UIBarButtonExtensin.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/19.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    /// AutoLayout
    public func constraintsConfigure(widthCnstant width: CGFloat, heightConstant height: CGFloat) {
        self.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
