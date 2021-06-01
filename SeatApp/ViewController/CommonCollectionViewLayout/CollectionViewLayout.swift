//
//  CollectionViewLayout.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/19.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    // 座席列表示欄セルレイアウト
    private var columnAttributes = [UICollectionViewLayoutAttributes]()
    // 座席行表示欄セルレイアウト
    private var rowAttributes = [UICollectionViewLayoutAttributes]()
    // 座席表示欄セルレイアウト
    private var dataAttributes = [[UICollectionViewLayoutAttributes]]()
    // 一番左上のセルレイアウト
    private var topLeftCellAttributes = UICollectionViewLayoutAttributes()
    // コンテンツサイズ
    private var contentSize: CGSize = .zero
    // 座席列表示欄・座席表示欄の横幅
    internal var cellWidth: CGFloat = 0

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        if collectionView.numberOfSections == 0 {
            return
        }
        // レイアウト設定
        generateItemAttributes(collectionView: collectionView)
    }

    override var collectionViewContentSize: CGSize { contentSize }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 一番左上のセル
        if indexPath.section == 0 && indexPath.row == 0 {
            return self.topLeftCellAttributes
        }
        // 座席列表示欄セル
        if indexPath.section == 0 {
             return self.rowAttributes[indexPath.row]
        }
        // 座席行表示欄セル
        if indexPath.row == 0 {
            return self.columnAttributes[indexPath.section]
        }
        // 座席表示欄セル
        return self.dataAttributes[indexPath.section][indexPath.row - 1]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView else {
            return [UICollectionViewLayoutAttributes]()
        }
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // 座席表示欄レイアウト
        for section in dataAttributes {
            // 重なっているセルを取得
            let items = section.filter { rect.intersects($0.frame) }
            for item in items {
                item.zIndex = 0
                layoutAttributes.append(item)
            }
        }
        // 座席行表示欄レイアウト
        for item in columnAttributes {
            // 画面左端固定
            item.frame.origin.x = collectionView.contentOffset.x
            item.zIndex = 100
            layoutAttributes.append(item)
        }
        // 座席列表示欄レイアウト
        for item in rowAttributes {
            // 画面上端固定
            item.frame.origin.y = collectionView.contentOffset.y
            item.zIndex = 1_000
            layoutAttributes.append(item)
        }
        // 一番左上のセルレイアウト
        // 画面左上固定
        self.topLeftCellAttributes.frame.origin.x = collectionView.contentOffset.x
        self.topLeftCellAttributes.frame.origin.y = collectionView.contentOffset.y
        self.topLeftCellAttributes.zIndex = 10_000
        layoutAttributes.append(self.topLeftCellAttributes)

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

// MARK: - Helpers
extension CollectionViewLayout {

    func generateItemAttributes(collectionView: UICollectionView) {
        columnAttributes.removeAll()
        rowAttributes.removeAll()
        dataAttributes.removeAll()

        // Y軸
        var columnOffset: CGFloat = 0
        // X軸
        var rowOffset: CGFloat = 0
        // 行番号セルの幅
        let rowCellWidth: CGFloat = 30
        // 列番号セルの高さ
        let columnCellheight: CGFloat = 30
        // データセルの高さ
        let dataCellHeight: CGFloat = self.cellWidth
        // データセルの幅
        let dataCellWidth: CGFloat = self.cellWidth
        let number0fSections = collectionView.numberOfSections
        // 左上のセルの幅
        let topLeftCellWidth: CGFloat = rowCellWidth
        // 左上のセルの高さ
        let topLeftCellHeight: CGFloat = columnCellheight
        // 左上のセル
        self.topLeftCellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        topLeftCellAttributes.frame = CGRect(x: 0, y: 0, width: topLeftCellWidth, height: topLeftCellHeight)
        columnOffset = topLeftCellHeight
        // 行番号セル
        for section in 1..<number0fSections {
            // セルの取得
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, with: IndexPath(item: 0, section: section))
            // セルのサイズ指定
            attributes.frame = CGRect(x: 0, y: columnOffset, width: rowCellWidth, height: dataCellHeight)
            self.columnAttributes.append(attributes)
            columnOffset += dataCellHeight
        }
        let numberOfItem = collectionView.numberOfItems(inSection: 0)
        rowOffset = topLeftCellWidth
        // 列番号セル
        for item in 1..<numberOfItem {
            // セルの取得
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, with: IndexPath(item: item, section: 0))
            // セルのサイズ指定
            attributes.frame = CGRect(x: rowOffset, y: 0, width: dataCellWidth, height: columnCellheight)
            self.rowAttributes.append(attributes)
            rowOffset += dataCellWidth
        }
        rowOffset = topLeftCellHeight
        // データセル
        for section in 1..<number0fSections {
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            columnOffset = topLeftCellWidth
            for item in 1..<numberOfItem {
                // セルの取得
                let dataCellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                // セルサイズの指定
                dataCellAttributes.frame = CGRect(x: columnOffset, y: rowOffset, width: dataCellWidth, height: dataCellHeight)
                columnOffset += dataCellWidth
                sectionAttributes.append(dataCellAttributes)
            }
            rowOffset += dataCellHeight
            self.dataAttributes.append(sectionAttributes)
        }
        contentSize = CGSize(width: columnOffset, height: rowOffset)
    }
}
