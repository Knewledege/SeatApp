//
//  UIImageViewExtension.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/17.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
extension UIImageView {
    func imageConfigure(name: String) {
        self.image = UIImage(named: name)
        self.contentMode = .scaleAspectFit
    }
}
