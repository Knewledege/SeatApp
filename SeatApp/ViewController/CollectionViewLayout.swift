//
//  CollectionViewLayout.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/19.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    fileprivate var columnAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate var rowAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate var dataAttributes = [[UICollectionViewLayoutAttributes]]()
    fileprivate var topLeftCellAttributes = UICollectionViewLayoutAttributes()

    var contentSize: CGSize = .zero
    var cellWidth: CGFloat = 0
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        if collectionView.numberOfSections == 0 {
            return
        }
        generateItemAttributes(collectionView: collectionView)
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section == 0 && indexPath.row == 0{
            return self.topLeftCellAttributes
        }
        if indexPath.section == 0{
             return self.rowAttributes[indexPath.row]
         }
        if indexPath.row == 0{
            return self.columnAttributes[indexPath.section]
        }
        return self.dataAttributes[indexPath.section][indexPath.row-1]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for section in dataAttributes{

            let items = section.filter{ rect.intersects($0.frame) }
            for item in items {
                item.zIndex = 0
                layoutAttributes.append(item)
            }
        }
        for item in columnAttributes{
            item.frame.origin.x = collectionView.contentOffset.x
            item.zIndex = 100
            layoutAttributes.append(item)
        }
        for item in rowAttributes{
            item.frame.origin.y = collectionView.contentOffset.y
            item.zIndex = 1000
            layoutAttributes.append(item)
        }
        self.topLeftCellAttributes.frame.origin.x = collectionView.contentOffset.x
        self.topLeftCellAttributes.frame.origin.y = collectionView.contentOffset.y
        self.topLeftCellAttributes.zIndex = 10000
        layoutAttributes.append(self.topLeftCellAttributes)

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
//    override func invalidateLayout() {
//        
//    }
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
        
        
        //左上のセルの幅
        let topLeftCellWidth: CGFloat = rowCellWidth
        //左上のセルの高さ
        let topLeftCellHeight: CGFloat = columnCellheight
        //左上のセル
        self.topLeftCellAttributes = UICollectionViewLayoutAttributes(forCellWith:IndexPath(item: 0, section: 0))
        topLeftCellAttributes.frame = CGRect(x: 0, y: 0, width: topLeftCellWidth, height: topLeftCellHeight)
        columnOffset = topLeftCellHeight
        //行番号セル
        for section in 1..<number0fSections{
            //セルの取得
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, with: IndexPath(item: 0, section: section))//(forCellWith:IndexPath(item: 0, section: section))
            //セルのサイズ指定
            attributes.frame = CGRect(x: 0, y: columnOffset, width: rowCellWidth, height: dataCellHeight)
            self.columnAttributes.append(attributes)
            columnOffset += dataCellHeight
        }
        let numberOfItem = collectionView.numberOfItems(inSection: 0)
//        print("numberOfitem", numberOfItem)
        rowOffset = topLeftCellWidth
        //列番号セル
        for item in 1..<numberOfItem{
            //セルの取得
//            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: item, section: 0))
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, with: IndexPath(item: item, section: 0))//(forCellWith: IndexPath(item: item, section: 0))
            //セルのサイズ指定
            attributes.frame = CGRect(x: rowOffset, y: 0, width: dataCellWidth, height: columnCellheight)
            self.rowAttributes.append(attributes)
            rowOffset += dataCellWidth
        }

        
        rowOffset = topLeftCellHeight
        //データセル
        for section in 1..<number0fSections{
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            columnOffset = topLeftCellWidth
            for item in 1..<numberOfItem{
                let dataCellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
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
