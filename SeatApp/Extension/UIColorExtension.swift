//  UIColorExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/21.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(rgb: [Int]) {
        let setRGB: [CGFloat] = rgb.map { CGFloat($0) / 255 }
        self.init(red: setRGB[0], green: setRGB[1], blue: setRGB[2], alpha: 1)
    }
}
