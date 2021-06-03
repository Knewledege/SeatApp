//  UIColorExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/21.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIColor {
    func mainColorGreen() -> UIColor {
        let setRGB = CommonColor.MAINCOLOR.map { CGFloat($0) / 255 }
        let color = UIColor(red: setRGB[0], green: setRGB[1], blue: setRGB[2], alpha: 1)
        return color
    }
}
