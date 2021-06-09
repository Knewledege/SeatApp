//
//  CustumContentsView.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/06/04.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class CustumContentsView: UIView {
    /* 座席列表示欄 */
    // 設定ビュー
    internal var topContentViews = [UIView]()
    // 表示画像
    private var topContentImages = [UIImageView]()
    // 表示テキスト
    private var topContentItemNumberLabels = [UILabel]()

    /* 座席行表示欄 */
    // 設定ビュー
    internal var leftContentViews = [UIView]()
    // 表示画像
    private var leftContentImages = [UIImageView]()
    // 表示テキスト
    private var leftContentItemNumberLabels = [UILabel]()

    /* 座席表示欄 */
    // 設定ビュー
    internal var seatContentViews = [[UIView]]()
    // 表示画像
    internal var seatContentImages = [[UIImageView]]()
    // 表示テキスト
    internal var seatContentCustomerNameLabels = [[UILabel]]()
    // 左上の余白用ビュー
    internal var dummyView = UIView()
    // スクロールビュー表示用
    internal var contentView = UIView()
    private var seatColumns: Int = 0
    private var seatRows: Int = 0
    // 座席列表示欄　高さ
    private let topContentViewHeight: CGFloat = 40
    // 座席行表示欄　幅
    private let leftContentViewWidth: CGFloat = 40
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    // スクロールビューコンテンツサイズ
    internal var seatViewContentSize: CGSize = .zero

    func contentViewConfigure(seatRows: Int, seatColumns: Int, screenWidth: CGFloat) {
        self.seatColumns = seatColumns
        self.seatRows = seatRows
        // 各ビューのサイズ指定
        self.width = (screenWidth - leftContentViewWidth) / ( CGFloat(self.seatColumns) - 1 )
        self.height = width + CGFloat(10)
        // 左上の余白設定
        dummyView.frame = CGRect(x: 0, y: 0, width: leftContentViewWidth, height: topContentViewHeight)
        dummyView.backgroundColor = UIColor().mainColorGreen()
        // 座席列表示各ビュー　設定
        for column in 0..<seatColumns - 1 {
            // 座席列表示ビュー
            topContentViews.append(UIView())
            topContentViews[column].frame.size = CGSize(width: width, height: topContentViewHeight)
            topContentViews[column].backgroundColor = UIColor().mainColorGreen()
            // 座席列表示ビュー　画像表示ビュー設定
            topContentImages.append(UIImageView())
            topContentViews[column].addSubview(topContentImages[column])
            // 座席列表示ビュー　テキスト表示ビュー設定
            topContentItemNumberLabels.append(UILabel())
            topContentItemNumberLabels[column].textAlignment = .center
            topContentViews[column].addSubview(topContentItemNumberLabels[column])
        }
        // 座席列表示ビュー　フレーム設定
        topContentViewFrameConfigure()
        // 座席列表示ビュー　オートレイアウト
        topContentViewAutoLayoutConfigure()
        // 座席行表示各ビュー　設定
        for row in 0..<seatRows - 1 {
            // 座席行表示ビュー
            leftContentViews.append(UIView())
            leftContentViews[row].frame.size = CGSize(width: leftContentViewWidth, height: height)
            leftContentViews[row].backgroundColor = UIColor().mainColorGreen()
            // 座席行表示ビュー　画像表示ビュー設定
            leftContentImages.append(UIImageView())
            leftContentViews[row].addSubview(leftContentImages[row])
            // 座席行表示ビュー　テキスト表示ビュー設定
            leftContentItemNumberLabels.append(UILabel())
            leftContentViews[row].addSubview(leftContentItemNumberLabels[row])
            leftContentItemNumberLabels[row].textAlignment = .center
        }
        // 座席行表示ビュー　フレーム設定
        leftContentViewFrameConfigure()
        // 座席行表示ビュー　オートレイアウト
        leftContentViewAutoLayoutConfigure()
        // 座席表示各ビュー　設定
        for row in 0..<seatRows - 1 {
            seatContentViews.append([UIView]())
            seatContentImages.append([UIImageView]())
            seatContentCustomerNameLabels.append([UILabel]())
            for column in 0..<seatColumns - 1 {
                // 座席表示ビュー
                seatContentViews[row].append(UIView())
                seatContentViews[row][column].backgroundColor = .white
                // 座席表示ビュー　画像表示ビュー設定
                seatContentImages[row].append(UIImageView())
                seatContentViews[row][column].addSubview(seatContentImages[row][column])
                // 座席表示ビュー　テキスト表示ビュー設定
                seatContentCustomerNameLabels[row].append(UILabel())
                seatContentCustomerNameLabels[row][column].textAlignment = .center
                seatContentCustomerNameLabels[row][column].adjustsFontSizeToFitWidth = true
                seatContentViews[row][column].addSubview(seatContentCustomerNameLabels[row][column])
            }
        }
        // 座席表示ビュー　フレーム設定
        seatContentViewFrameConfigure()
        // 座席表示ビュー　オートレイアウト
        seatContentViewAutoLayoutConfigure()
        topContentViews.forEach { view in
            // スクロール表示用に追加
            contentView.addSubview(view)
            // 座席列表示ビューのzindexを前面に
            contentView.bringSubviewToFront(view)
        }
        leftContentViews.forEach { view in
            // スクロール表示用に追加
            contentView.addSubview(view)
            // 座席行表示ビューのzindexを前面に
            contentView.bringSubviewToFront(view)
        }
        seatContentViews.forEach { views in
            views.forEach { view in
                // スクロール表示用に追加
                contentView.addSubview(view)
                // 座席表示ビューのzindexを背面に
                contentView.sendSubviewToBack(view)
            }
        }
        // スクロール表示用に追加
        contentView.addSubview(dummyView)
        // 左上の余白ビューのzindexを前面に
        contentView.bringSubviewToFront(dummyView)
        contentView.frame.size = seatViewContentSize
    }
    /// 座席列表示ビュー　フレーム設定
    private func topContentViewFrameConfigure() {
        var x: CGFloat = leftContentViewWidth
        let y: CGFloat = 0
        topContentViews.forEach { view in
            view.frame = CGRect(x: x, y: y, width: view.frame.width, height: view.frame.height)
               x += width
        }
    }
    /// 座席列表示ビュー　オートレイアウト
    private func topContentViewAutoLayoutConfigure() {
        topContentViews.enumerated().forEach { column, view in
             topContentImages[column].translatesAutoresizingMaskIntoConstraints = false
             topContentImages[column].heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
             topContentImages[column].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             topContentImages[column].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
             topContentItemNumberLabels[column].translatesAutoresizingMaskIntoConstraints = false
             topContentItemNumberLabels[column].heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
             topContentItemNumberLabels[column].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             topContentItemNumberLabels[column].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
         }
    }
    /// 座席行表示ビュー　フレーム設定
    private func leftContentViewFrameConfigure() {
        let x: CGFloat = 0
        var y: CGFloat = topContentViewHeight
        leftContentViews.forEach { view in
            view.frame = CGRect(x: x, y: y, width: view.frame.width, height: view.frame.height)
               y += height
        }
    }
    /// 座席行表示ビュー　オートレイアウト
    private func leftContentViewAutoLayoutConfigure() {
        leftContentViews.enumerated().forEach { row, view in
            leftContentImages[row].translatesAutoresizingMaskIntoConstraints = false
            leftContentImages[row].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
            leftContentImages[row].centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            leftContentImages[row].widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

            leftContentItemNumberLabels[row].translatesAutoresizingMaskIntoConstraints = false
            leftContentItemNumberLabels[row].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
            leftContentItemNumberLabels[row].centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            leftContentItemNumberLabels[row].widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }
    /// 座席表示ビュー　フレーム設定
    private func seatContentViewFrameConfigure() {
        var x: CGFloat = leftContentViewWidth
        var y: CGFloat = topContentViewHeight
        seatContentViews.forEach { views in
            x = leftContentViewWidth
            views.forEach { view in
                view.frame = CGRect(x: x, y: y, width: width, height: height)
                x += width
            }
            y += height
        }
        self.seatViewContentSize = CGSize(width: x, height: y)
    }
    /// 座席表示ビュー　オートレイアウト
    private func seatContentViewAutoLayoutConfigure() {
        seatContentViews.enumerated().forEach { row, views in
            views.enumerated().forEach { column, _ in
                seatContentImages[row][column].translatesAutoresizingMaskIntoConstraints = false
                seatContentImages[row][column].heightAnchor.constraint(equalTo: seatContentViews[row][column].heightAnchor, multiplier: 0.9).isActive = true
                seatContentImages[row][column].widthAnchor.constraint(equalTo: seatContentViews[row][column].widthAnchor, multiplier: 0.9).isActive = true
                seatContentImages[row][column].centerXAnchor.constraint(equalTo: seatContentViews[row][column].centerXAnchor).isActive = true

                seatContentCustomerNameLabels[row][column].translatesAutoresizingMaskIntoConstraints = false
                seatContentCustomerNameLabels[row][column].heightAnchor.constraint(equalTo: seatContentViews[row][column].heightAnchor, multiplier: 0.1).isActive = true
                seatContentCustomerNameLabels[row][column].widthAnchor.constraint(equalTo: seatContentViews[row][column].widthAnchor, multiplier: 0.9).isActive = true
                seatContentCustomerNameLabels[row][column].centerXAnchor.constraint(equalTo: seatContentViews[row][column].centerXAnchor).isActive = true
                seatContentCustomerNameLabels[row][column].topAnchor.constraint(equalTo: seatContentImages[row][column].bottomAnchor).isActive = true
            }
        }
    }
    /// 各座席ビューの　表示画像と表示テキスト設定
    func setContent(seatNumber: [[CellType]], seatName: [[String]]) {
        topContentViews.indices.forEach {
            if seatName[0][$0 + 1] != Common.NOCUTMERNAME {
                topContentImages[$0].image = UIImage(named: seatNumber[0][$0 + 1].imageName)
                topContentItemNumberLabels[$0].text = seatName[0][$0 + 1]
            }
        }
        leftContentViews.indices.forEach {
            if seatName[$0 + 1][0] != Common.NOCUTMERNAME {
                leftContentImages[$0].image = UIImage(named: seatNumber[$0 + 1][0].imageName)
                leftContentItemNumberLabels[$0].text = seatName[$0 + 1][0]
            }
        }
        seatContentViews.enumerated().forEach { row, views in
             views.enumerated().forEach { column, _ in
                seatContentImages[row][column].image = nil
                seatContentCustomerNameLabels[row][column].text = ""
                switch seatNumber[row + 1][column + 1] {
                case .passCell:
                     break
                default:
                    seatContentImages[row][column].image = UIImage(named: seatNumber[row + 1][column + 1].imageName)
                }
                if seatName[row + 1][column + 1] != Common.NOCUTMERNAME {
                    seatContentCustomerNameLabels[row][column].text = seatName[row + 1][column + 1]
                }
            }
        }
    }
    /// 座席表示ビューにドロップ&ドラッグの設定を追加
    func addDragDropIntaraction(dragInteractionDelegate: UIDragInteractionDelegate, dropInteractionDelegate: UIDropInteractionDelegate) {
        seatContentViews.forEach { views in
            views.forEach { view in
                let dragInteraction = UIDragInteraction(delegate: dragInteractionDelegate)
                view.addInteraction(dragInteraction)
                let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
                view.addInteraction(dropInteraction)
                view.isUserInteractionEnabled = true
            }
        }
    }
}
