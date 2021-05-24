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
    @IBOutlet internal weak var contentImage: UIImageView!
    @IBOutlet internal weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentImage.contentMode = .scaleAspectFit
    }
    override func prepareForReuse() {
           super.prepareForReuse()
           self.backgroundColor = .white
           contentImage.image = nil
           numberLabel.text = nil
       }
       
       internal func imageConfigure(name: String){
           if name != "none" {
               contentImage.imageConfigure(name: name)
           }
       }
       internal func cellBackgroundColor(color: UIColor){
           self.backgroundColor = color
       }
       internal func rowLabelConfigure(text: String){
           if text != "none" {
               numberLabel.text = text
           }
       }
}
