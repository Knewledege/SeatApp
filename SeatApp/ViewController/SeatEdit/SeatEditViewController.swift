//
//  SeatEditViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

public class SeatEditViewController: UIViewController {
    // 座席行表示欄、座席列表示欄、座席表示欄　用コレクションビュー
    @IBOutlet private weak var seatEditCollectionView: UICollectionView!
    // プレゼンター
    private var presenter: SeatEditInput?
    // 便ID
    internal var flightID: Int = 0
    // 座席編集痕跡判定
    private var changeSeat = false
    // セルカスタムレイアウト
    private let layout = CollectionViewLayout()

    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = SeatEditPresenter(delegate: self)
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        // OKボタン・キャンセルボタン設定
        setRightBarButtonItem()
        // セルの横幅設定
        layout.cellWidth = (UIScreen.main.bounds.width - 30) / (CGFloat(self.presenter?.getSeatColumn() ?? 0) - 1)
        // セルのカスタムレイアウト指定
        seatEditCollectionView.collectionViewLayout = layout
        seatEditCollectionView.register(UINib(nibName: FlightSeatCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FlightSeatCollectionViewCell.className)
               seatEditCollectionView.register(UINib(nibName: FlightItemNumberCollectionViewCell.className, bundle: nil), forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className)
        seatEditCollectionView.dataSource = self
        seatEditCollectionView.dropDelegate = self
        seatEditCollectionView.dragDelegate = self
        seatEditCollectionView.dragInteractionEnabled = true
    }
    override public func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(true)
        CommonLog.LOG(massege: "")
    }
    override public func viewWillLayoutSubviews() {
        CommonLog.LOG(massege: "")
    }
    override public func viewDidLayoutSubviews() {
        CommonLog.LOG(massege: "")
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if #available(iOS 13.0, *) {
             presentingViewController?.endAppearanceTransition()
         }
        CommonLog.LOG(massege: "")
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        CommonLog.LOG(massege: "")
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if #available(iOS 13.0, *) {

            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
        CommonLog.LOG(massege: "")
    }
    deinit {
        CommonLog.LOG(massege: "")
    }
    /// OKボタン・キャンセルボタン設定
    private func setRightBarButtonItem() {
        let okButton = UIButton(type: .custom)
        okButton.buttonConfigure(imageName: Common.OKBTN, target: self, action: #selector(doneEdit))
        let cancelButton = UIButton(type: .custom)
        cancelButton.buttonConfigure(imageName: Common.CANCELBTN, target: self, action: #selector(cancelEdit))

        let okBarItem = UIBarButtonItem(customView: okButton)
        let cancelBarItem = UIBarButtonItem(customView: cancelButton)

        okBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
        cancelBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
        self.navigationItem.rightBarButtonItems = [cancelBarItem, okBarItem]
    }
    /// OKボタン押下時
    @objc
    private func doneEdit() {
        CommonLog.LOG(massege: CommonLogMassege.DONEEDITBUTTON)
        //　座席編集をしていたら
        if self.changeSeat {
            let alert = UIAlertController(title: "座席を決定してよろしいですか？", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "はい", style: .default) { _ in
                // 顧客情報更新をプレゼンターに依頼
                self.presenter?.updateSeatData()
                CommonLog.LOG(massege: CommonLogMassege.SEATUPDATE)
            }
            let cancelAction = UIAlertAction(title: "いいえ", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    /// キャンセルボタン押下時
    @objc
    private func cancelEdit() {
        CommonLog.LOG(massege: CommonLogMassege.CANCELSEATEDITBUTTON)
        // 座席を編集していた場合
        if self.changeSeat {
            let alert = UIAlertController(title: "座席の編集を破棄しますがよろしいですか？", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "はい", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "いいえ", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
            CommonLog.LOG(massege: CommonLogMassege.SEATEDITBUTTONCANCELALERT)
        } else {
        // 座席を編集していない場合
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension SeatEditViewController: SeatEditOutput {
    /// 便名表示　設定
    func setLeftBarButtonItem(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: .none, action: .none)
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    /// 顧客情報更新結果　表示
    /// 表示後　座席表示画面（表示モード）に遷移
    func updateCustomerResultAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - UICollectionViewDataSource
extension SeatEditViewController: UICollectionViewDataSource {
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
            guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),
                let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else {
                  return supplementaryCell
            }
            // 座席行・列画像名　及び　行・列数をプレゼンターに取得依頼
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
extension SeatEditViewController: UICollectionViewDropDelegate {
    /// ドロップ確定時
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let item = coordinator.items.first,
               let destinationIndexPath = coordinator.destinationIndexPath,
               let sourceIndexPath = item.sourceIndexPath else { return }
        self.presenter?.resetCellInfo(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
           collectionView.performBatchUpdates({
               collectionView.reloadItems(at: [sourceIndexPath])
               collectionView.reloadItems(at: [destinationIndexPath])
               }, completion: nil)
           coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        self.changeSeat = true
        CommonLog.LOG(massege: CommonLogMassege.SEATDROP)
    }
    /// ドロップ位置指定時
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                               withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // 画面外や座席表示欄外　はドロップをキャンセル
        guard let indexPath = destinationIndexPath else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        // プレゼンターに選択した座席の画像を依頼
        if let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row) {
            // 既に顧客がいる座席（座席画像がseatではない座席）もドロップはキャンセル
            switch seatImage {
            case .seat:
                return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
            default:
                return UICollectionViewDropProposal(operation: .cancel)
            }
        }
        return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
    }
}
extension SeatEditViewController: UICollectionViewDragDelegate {
    /// ドラッグ時
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        CommonLog.LOG(massege: CommonLogMassege.SEATDRAGSTART)
        // 座席行・列表示欄選択時は何もしない
        if indexPath.section == 0 || indexPath.row == 0 {
            return []
        }
        // 選択した座席の画像をプレゼンターに依頼
        guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row) else {
            return []
        }
        // 選択したセルが顧客の席以外の場合何もしない
        switch seatImage {
        case .passCell:
            return []
        case .seat:
            return []
        case .leftCell:
            return []
        case .topCell:
            return []
        default:
            // 選択した座席に既に顧客がいる場合、ドラッグ
            if let seat = UIImage(named: seatImage.imageName) {
                let itemProvider = NSItemProvider(object: seat)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                return [dragItem]
            }
        }

        return []
    }
}
