//
//  FlightSelectionViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit
public class FlightSelectionViewController: UIViewController {
    // MARK: - Parameters
    // タイトル画像
    @IBOutlet private weak var titleImageView: UIImageView!
    // タイトル
    @IBOutlet private weak var titleLabel: UILabel!
    // 便名選択欄
    @IBOutlet private weak var flightNameField: UITextField!
    // 便名選択欄　選択ボタン
    @IBOutlet private weak var flightNamePickerButton: UIButton! {
        didSet {
            flightNamePickerButton.addTarget(self, action: #selector(setPopOver), for: .touchUpInside)
        }
    }
    // 便情報表示欄
    @IBOutlet private weak var flightDetailsTextView: UITextView! {
        didSet {
            flightDetailsTextView.backgroundColor = .white
            flightDetailsTextView.isSelectable = false
        }
    }
    // 座席表示画面（表示モード）遷移ボタン
    @IBOutlet private weak var viewTransitionButton: UIButton! {
        didSet {
           viewTransitionButton.addTarget(self, action: #selector(performDisplay), for: .touchUpInside)
        }
    }
    // プレゼンター
    private var presenter: FlightSelectionInput?
    // ピッカー表示用ポップオーバービュー
    private let popoverViewController = UIViewController()
    // 便ID
    private var flightID: Int?

    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = FlightSelectionPresenter(delegate: self)
        // 便情報をプレセンターに依頼
        presenter?.setFlightInfo()
        // ポップオーバービュー初期設定
        popOverConfigure()
    }
    // 便名選択欄　選択ボタン押下時
    @objc
    private func setPopOver(_ sender: UIButton) {
        sender.isSelected.toggle()
        // ピッカーを表示するとき
        if sender.isSelected {
            popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popoverViewController.popoverPresentationController?.sourceView = flightNameField
            popoverViewController.popoverPresentationController?.delegate = self
            self.present(popoverViewController, animated: true, completion: nil)
        } else {
        // ピッカーを閉じるとき
            popoverViewController.dismiss(animated: true, completion: nil)
        }
    }
    /// 座席表示画面（表示モード）遷移ボタン押下時
    @objc
    private func performDisplay() {
        CommonLog.LOG(massege: CommonLogMassege.PUSHPERFORMDISPLAYBUTTON)
        guard let id = flightID else {
            // flightIDがnilの場合、便が選択されていない為アラート表示
            alert()
            CommonLog.LOG(massege: CommonLogMassege.DIDNOTSELECTFLIGHTALERT)
            return
        }
        CommonLog.LOG(massege: CommonLogMassege.TRANSIOTIONFLIGHTSEATDISPLAY)
        // 座席表示画面（表示モード）へ遷移
        Router.perform(id: id + 1, to: .flightSeat, from: self)
    }
    /// 便名選択ピッカー OKボタン押下時
    @objc
    private func donePicker() {
        CommonLog.LOG(massege: CommonLogMassege.DIDSELECTPICKER)
        // ピッカーのデリゲートを用い、didSelectRowをテキストフィールドのタグに格納済み
        flightID = flightNameField.tag
        if let id = flightID {
            // 便名選択欄の選択ボタンを選択済みに変更
            flightNamePickerButton.isSelected.toggle()
            // ポップオーバー非表示
            popoverViewController.dismiss(animated: true, completion: nil)
            // ピッカーで選択した便名をテキストフィールドに指定
            flightNameField.text = presenter?.setFlightName(row: id)
            flightNameField.endEditing(true)
            // ピッカーで選択した便情報をプレゼンターに依頼
            presenter?.setFlightDetails(id: id)
        }
    }
    /// 便名選択ピッカー キャンセルボタン押下時
    @objc
    private func cancelPicker() {
        CommonLog.LOG(massege: CommonLogMassege.CANCELSELECTPICKER)
        // ポップオーバー非表示
        popoverViewController.dismiss(animated: true, completion: nil)
        flightNameField.endEditing(true)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonLog.LOG(massege: "")
    }
    override public func viewWillLayoutSubviews() {
        CommonLog.LOG(massege: "")
    }
    // MARK: - ConstraintsConfigure
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension FlightSelectionViewController {
    /// ピッカー上部のツールバー設定
    private func toolBarConfigure() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: flightNameField.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelPicker))
        toolBar.setItems([doneButton, cancelButton], animated: false)
        return toolBar
    }
    /// ピッカー生成
    private func pickerConfigure() -> UIPickerView {
        let flightPicker = UIPickerView(frame: CGRect(x: 0, y: 45, width: flightNameField.frame.width, height: 210))
        flightPicker.delegate = self
        flightPicker.dataSource = self
        return flightPicker
    }
    /// ポップオーバー初期設定
    private func popOverConfigure() {
        let toolBar = toolBarConfigure()
        let flightPicker = pickerConfigure()
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(toolBar)
        popoverView.addSubview(flightPicker)
        popoverViewController.view = popoverView
        popoverViewController.view.frame = CGRect(x: 0, y: 0, width: flightPicker.frame.width, height: flightPicker.frame.height)
        popoverViewController.preferredContentSize = flightPicker.frame.size
        popoverViewController.modalPresentationStyle = .popover
    }
    /// 遷移失敗時アラート
    private func alert() {
        let alert = UIAlertController(title: "便名を選択してください。", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
extension FlightSelectionViewController: FlightSelectionOutput {
    /// 便情報表示欄に便情報表示
    public func setTextView(text: String) {
        flightDetailsTextView.text = text
    }
}
extension FlightSelectionViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
       .none
    }
    /// ポップオーバー外選択時
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        /// ポップオーバー非表示のため、便名選択欄　選択ボタンも非選択状態にする
        flightNamePickerButton.isSelected.toggle()
    }
}
extension FlightSelectionViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // テキストフィールドのタグに記憶させ、ツールバーのOKボタン選択時にflightIDに設定する
        self.flightNameField.tag = row
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 便名をプレゼンターに依頼
        return presenter?.setFlightName(row: row)
    }
}
extension FlightSelectionViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 全便の数をプレゼンターに依頼
        return presenter?.setFlightCount() ?? 0
    }
}
