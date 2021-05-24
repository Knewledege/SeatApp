//
//  UIButtonExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/16.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIButton {
    func buttonConfigure(imageName: String, target: Any, action: Selector){
        self.setImage(UIImage(named: imageName), for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
