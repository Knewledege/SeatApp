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
    @IBOutlet private weak var seatEditScrollView: UIScrollView!
    // プレゼンター
    private var presenter: SeatEditInput?
    // 便ID
    internal var flightID: Int = 0
    // 座席編集痕跡判定
    private var changeSeat = false
    // カスタムレイアウト
    private let contentsView = CustumContentsView()
    // 変更前の座席ビューのrow
    private var seatRow = 0
    // 変更前の座席ビューのcolumn
    private var seatColumn = 0

    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = SeatEditPresenter(delegate: self)
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        // OKボタン・キャンセルボタン設定
        setRightBarButtonItem()
        // スクロールビューの設定
        seatEditScrollView.delegate = self
        seatEditScrollView.maximumZoomScale = 8.0
        seatEditScrollView.minimumZoomScale = 1.0
        // スクロールビューに配置するビューの生成
        contentsView.contentViewConfigure(seatRows: self.presenter?.getSeatRow(id: flightID) ?? 0, seatColumns: self.presenter?.getSeatColumn() ?? 0, screenWidth: UIScreen.main.bounds.width)
        // スクロールビューにUIViewを追加
        seatEditScrollView.addSubview(contentsView.contentView)
        seatEditScrollView.contentSize = contentsView.seatViewContentSize
        // 座席行・列表示欄、座席表示欄の全画像を取得
        let seatNumber = self.presenter?.getAllSeatNumber() ?? [[CellType.passCell]]
        // 座席行・列表示欄、座席表示欄の全テキストを取得
        let seatName = self.presenter?.getAllSeatName() ?? [[Common.NOCUTMERNAME]]
        // 座席行・列表示欄、座席表示欄の画像とテキストを設定
        contentsView.setContent(seatNumber: seatNumber, seatName: seatName)
        // ドロップ&ドラッグ　デリゲート設定
        let dragDelegate: UIDragInteractionDelegate = self
        let dropDelegate: UIDropInteractionDelegate = self
        // ドロップ&ドラッグ　デリゲートを全座席に設定
        contentsView.addDragDropIntaraction(dragInteractionDelegate: dragDelegate, dropInteractionDelegate: dropDelegate)
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
extension SeatEditViewController: UIScrollViewDelegate {
    /// ズーム対象を設定
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentsView.contentView
    }
    /// ズームしたら座席行・列表示欄を端に固定
    /// scrollView.zoomScaleで割ってる理由は拡大縮小際の比率を与えないと、スクロール量にズレが生じるため
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y / scrollView.zoomScale
        let offsetX = scrollView.contentOffset.x / scrollView.zoomScale
        contentsView.dummyView.frame.origin = CGPoint(x: offsetX, y: offsetY)
        contentsView.topContentViews.forEach { topContent in
            topContent.frame.origin.y = offsetY
        }
        contentsView.leftContentViews.forEach { leftContent in
            leftContent.frame.origin.x = offsetX
        }
    }
}
extension SeatEditViewController: UIDragInteractionDelegate {
    /// ドラッグ時
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        // ドラッグしたビューの画像オブジェクト
        var seatImage: UIImage?
        // ドラッグ中のビュー
        guard let dragView = interaction.view else {
            return []
        }
        // ドラッグ中のビューの座標を取得
        let dragPoint = session.location(in: dragView)
        // ドラッグ中のビューの特定
        guard let selectView = dragView.hitTest(dragPoint, with: nil)  else {
            return []
        }
        // ドラッグ中のビューを座席ビューと比較
        contentsView.seatContentViews.enumerated().forEach { row, views in
            views.enumerated().forEach { column, seatView in
                // 座席ビューと一致した場合、座席にあるビューをドラッグしている
                if seatView == selectView {
                    // 一致した際のrow,columnを使って座席に設定しているテキストを取得
                    let text = contentsView.seatContentCustomerNameLabels[row][column].text ?? ""
                    // 座席のテキストが設定されている場合、ドラッグしているビューは顧客の席のためドラッグ可能とする
                    if !text.isEmpty {
                        // ドラッグする画像を設定
                        seatImage = contentsView.seatContentImages[row][column].image
                        // ドラッグする座席の要素番号を保存、ドロップ時に使用
                        seatRow = row
                        seatColumn = column
                    }
                }
            }
        }
        // ドラッグしている画像を取得、ドラッグするアイテムとして登録
        if let image = seatImage {
            let itemProvider = NSItemProvider(object: image)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        }
        return []
    }
}
extension SeatEditViewController: UIDropInteractionDelegate {
    // ドロップ時
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // ドロップを禁止するかどうか
        var dropCancel = true
        // ドロップ中のビュー
        guard let dragView = interaction.view else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        // ドロップ中のビューの座標を取得
        let dragPoint = session.location(in: dragView)
        // ドロップ中のビューの特定
        guard let selectView = dragView.hitTest(dragPoint, with: nil)  else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        // ドロップ中のビューを座席ビューと比較
        contentsView.seatContentViews.enumerated().forEach { row, views in
            views.enumerated().forEach { column, seatView in
                // 座席ビューと一致した場合、座席にあるビューにドロップしている
                if seatView == selectView {
                    // 一致した際のrow,columnを使って座席に設定しているテキストを取得
                    let text = contentsView.seatContentCustomerNameLabels[row][column].text ?? ""
                    // 一致した際のrow,columnを使って座席に設定している画像を取得
                    let image = contentsView.seatContentImages[row][column].image
                    // 座席のテキストが空白且つ画像が設定されてるなら空席のためドロップ可能
                    // それ以外は既に顧客がいるか通路のためドロップできない
                    if text.isEmpty && image != nil {
                        dropCancel = false
                    }
                }
            }
        }
        if dropCancel {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
    }
    // ドロップ確定時
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // ドロップ中のビュー
        guard let dragView = interaction.view else {
            return
        }
        // ドロップ中のビューの座標を取得
        let dragPoint = session.location(in: dragView)
        // ドロップ中のビューの特定
        guard let selectView = dragView.hitTest(dragPoint, with: nil)  else {
            return
        }
        // ドロップ中のビューを座席ビューと比較
        contentsView.seatContentViews.enumerated().forEach { row, views in
            views.enumerated().forEach { column, seatView in
                // 座席ビューと一致した場合、座席にあるビューにドロップ
                if seatView == selectView {
                    // ドロップした座席ビューの要素番号を取得
                    /*
                    要素番号にプラス１をしている理由は、
                    FlightModelの配列は座席行・列表示欄及び座席表示欄を全て含むのに対し、
                    contentsView.seatContentViewsは座席表示欄しか含まないため
                    */
                    let destinationIndexPath = IndexPath(row: column + 1, section: row + 1)
                    // ドラッグした座席ビューの要素番号を取得
                    let sourceIndexPath = IndexPath(row: seatColumn + 1, section: seatRow + 1)
                    // ドロップ後、FlightModelのデータを書き換える
                    self.presenter?.resetCellInfo(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
                }
            }
        }
        // ドロップ後の座席画像とテキストを取得
        let seatNumber = self.presenter?.getAllSeatNumber() ?? [[CellType.passCell]]
        let seatName = self.presenter?.getAllSeatName() ?? [[Common.NOCUTMERNAME]]
        // 座席の画像とテキストを設定
        contentsView.setContent(seatNumber: seatNumber, seatName: seatName)
        // 編集したことを保存
        self.changeSeat = true
        CommonLog.LOG(massege: CommonLogMassege.SEATDROP)
    }
}
