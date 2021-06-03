//
//  FlightSeatViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//
import UIKit
public class FlightSeatViewController: UIViewController {
    // 座席行表示欄、座席列表示欄、座席表示欄　用コレクションビュー
    @IBOutlet private weak var flightSeatCollectionView: UICollectionView!
    // プレゼンター
    private var presenter: FlightSeatInput?
    // 便ID
    internal var flightID: Int = 0
    // セルカスタムレイアウト
    let layout = CollectionViewLayout()

    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = FlightSeatPresenter(delegate: self)
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        // 座席編集ボタン設定
        setRightBarButtonItem()
        // セルの横幅設定
        layout.cellWidth = (UIScreen.main.bounds.width - 30) / (CGFloat(self.presenter?.getSeatColumn() ?? 0) - 1)
        // セルのカスタムレイアウト指定
        flightSeatCollectionView.collectionViewLayout = layout
        flightSeatCollectionView.register(UINib(nibName: FlightSeatCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FlightSeatCollectionViewCell.className)
        flightSeatCollectionView.register(UINib(nibName: FlightItemNumberCollectionViewCell.className, bundle: nil), forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className)
        flightSeatCollectionView.dataSource = self
        // 拡大縮小用　ジャスチャー設定
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchCell))
        flightSeatCollectionView.addGestureRecognizer(pinch)
    }
     override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonLog.LOG(massege: "")
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        self.flightSeatCollectionView.reloadData()
    }
    override public func viewWillLayoutSubviews() {
       CommonLog.LOG(massege: "")
    }
    override public func viewDidLayoutSubviews() {
       CommonLog.LOG(massege: "")
    }
    override public func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(true)
       CommonLog.LOG(massege: "")
    }
    override public func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(true)
       CommonLog.LOG(massege: "")
    }
    override public func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(true)
       CommonLog.LOG(massege: "")
    }
    deinit {
       CommonLog.LOG(massege: "")
    }
    /// 座席編集ボタン設定
     private func setRightBarButtonItem() {
         let editButton = UIButton(type: .custom)
         editButton.buttonConfigure(imageName: Common.EDITBTN, target: self, action: #selector(pushDisplay))
         let editBarItem = UIBarButtonItem(customView: editButton)

         editBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
         self.navigationItem.rightBarButtonItem = editBarItem
     }
    /// セル拡大縮小ジャスチャー検知時
    @objc
    private func pinchCell(_ sender: UIPinchGestureRecognizer) {
        layout.cellWidth = (layout.cellWidth * sender.scale)
        flightSeatCollectionView.reloadData()
    }
    /// 便名表示　ボタン押下時
    /// 便選択画面へ遷移
    @objc
    private func popDisplay() {
        CommonLog.LOG(massege: CommonLogMassege.BACKFLIGHTSELECTDISPLAY)
        self.navigationController?.popViewController(animated: true)
    }
    /// 座席編集　ボタン押下時
    /// 座席表示画面（編集モード）へ遷移
    @objc
    private func pushDisplay() {
        CommonLog.LOG(massege: CommonLogMassege.TRANSIOTIONSEATEDITDISPLAY)
        Router.perform(id: flightID, to: .seatEdit, from: self)
    }
}
extension FlightSeatViewController: FlightSeatOutput {
    /// 便名表示　及びツールバー設定
    func setLeftBarButtonItem(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popDisplay))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
}
// MARK: - UICollectionViewDataSource
extension FlightSeatViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 座席行数をプレゼンターに取得依頼
        return self.presenter?.getSeatRow(id: flightID) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 座席列数をプレゼンターに取得依頼
        return self.presenter?.getSeatColumn() ?? 0
    }
    /// 座席表示欄　セル設定
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightSeatCollectionViewCell.className, for: indexPath) as? FlightSeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        // 座席表示画像名　及び　「顧客情報」テーブル「名前」をプレゼンターに取得依頼
        guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),
            let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else {
          return cell
        }
        // 座席行・列表示欄　背景緑
        if indexPath.section == 0 || indexPath.row == 0 {
            cell.cellBackgroundColor(color: UIColor().mainColorGreen())
        } else {
        // 座席表示欄　背景白
            cell.cellBackgroundColor(color: .white)
        }
        // セルの画像設定
        cell.imageConfigure(type: seatImage)
        // 顧客名表示ラベル設定
        cell.rowLabelConfigure(text: seatName)

        return cell
    }
    /// 座席行・列表示　セル設定
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryCell = collectionView.dequeueReusableSupplementaryView(ofKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className, for: indexPath) as? FlightItemNumberCollectionViewCell else {
            return UICollectionReusableView()
        }
        // 座席行・列表示欄　の設定
        if indexPath.section == 0 || indexPath.row == 0 {

            // 座席行・列画像名　及び　行・列数をプレゼンターに取得依頼
            guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),
                let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else {
                  return supplementaryCell
            }
            supplementaryCell.cellBackgroundColor(color: UIColor().mainColorGreen())
            // セルの画像設定
            supplementaryCell.imageConfigure(type: seatImage)
            // 行数表示ラベル設定
            supplementaryCell.rowLabelConfigure(text: seatName)
            // 列数表示ラベル設定
            if indexPath.section == 0 {
                // アルファベット表記
                supplementaryCell.columnLabelConfigure(text: seatName)
            }
        }

        return supplementaryCell
    }
}
