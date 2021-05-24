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
    // Titles parameters
    private let titleStackView: UIStackView = UIStackView(frame: .zero)
    private let titleImageView: UIImageView = UIImageView(frame: .zero)
    private let titleLabel: UILabel = UILabel(frame: .zero)
    // Flight Infomation parameters
    private let flightInfoStackView: UIStackView = UIStackView(frame: .zero)
    // Flight Names parameters
    private let flightNameBackgroundView: UIView = UIView(frame: .zero)
    private let flightNameStackView: UIStackView = UIStackView(frame: .zero)
    private let flightNameTitleLabel: UILabel = UILabel(frame: .zero)
    private let flightNameField: UITextField = UITextField(frame: .zero)
    // Flight Details parameters
    private let flightDetailsBackgroundView: UIView = UIView(frame: .zero)
    private let flightDetailsStackView: UIStackView = UIStackView(frame: .zero)
    private let flightDetailsTitleLabel: UILabel = UILabel(frame: .zero)
    private let flightDetailsTextView: UITextView = UITextView(frame: .zero)
    // View Transition Button
    private let viewTransitionButton: UIButton = UIButton(frame: .zero)
    // Presenter
    private var presenter: FlightSelectionInput?
    // PopOverViewController
    private let popoverViewController = UIViewController()
    // Choice Flight id
    private var flightID: Int?
    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = FlightSelectionPresenter(delegate: self)
        presenter?.setFlightInfo()
        self.view.addSubview(titleStackView)
        self.view.addSubview(flightInfoStackView)
        self.view.addSubview(viewTransitionButton)
        titleStackView.stackViewConfigure(axis: .horizontal, alignment: .center, distribution: .fill)
        titleImageView.imageConfigure(name: CommonImageResource.SEAT)
        titleStackView.addArrangedSubview(titleImageView)
        titleLabel.labelConfigure(textAlignment: .center, size: 30, weight: .bold)
        titleLabel.setText(text: CommonImageResource.TITLE, color: UIColor.init(rgb: CommonColor.MAINCOLOR))
        titleStackView.addArrangedSubview(titleLabel)
        flightInfoStackView.stackViewConfigure(axis: .vertical, alignment: .fill, distribution: .equalSpacing)
        flightInfoStackView.addArrangedSubview(flightNameBackgroundView)
        flightNameBackgroundView.backgroundColor = .systemGray5
        flightNameStackView.stackViewConfigure(axis: .vertical, alignment: .fill, distribution: .equalSpacing)
        flightNameBackgroundView.addSubview(flightNameStackView)
        flightNameTitleLabel.labelConfigure(textAlignment: .center, size: 20, weight: .light)
        flightNameStackView.addArrangedSubview(flightNameTitleLabel)
        flightNameTitleLabel.setText(text: CommonFlightSelection.FLIGHTNAMESTITLE, color: .black)
        flightNameStackView.addArrangedSubview(flightNameField)
        flightInfoStackView.addArrangedSubview(flightDetailsBackgroundView)
        flightDetailsBackgroundView.backgroundColor = .systemGray5
        flightDetailsStackView.stackViewConfigure(axis: .vertical, alignment: .fill, distribution: .equalSpacing)
        flightDetailsBackgroundView.addSubview(flightDetailsStackView)
        flightDetailsTitleLabel.labelConfigure(textAlignment: .center, size: 20, weight: .light)
        flightDetailsStackView.addArrangedSubview(flightDetailsTitleLabel)
        flightDetailsTitleLabel.setText(text: CommonFlightSelection.FLIGHTDETAILSTITLE, color: .black)
        flightDetailsStackView.addArrangedSubview(flightDetailsTextView)
        textViewConfigure()
        viewTransitionButton.setImage(UIImage(named: CommonImageResource.TOPEDITBTN), for: .normal)
        viewTransitionButton.addTarget(self, action: #selector(performDisplay), for: .touchUpInside)
        textFieldConfigure()
        pickerConfigure()
        popOverConfigure()
    }
    @objc fileprivate func performDisplay() {
        CommonLog.LOG(massege: CommonLomMassege.PUSHPERFORMDISPLAYBUTTON)
        guard let id = flightID else {
            alert()
            CommonLog.LOG(massege: CommonLomMassege.DIDNOTSELECTFLIGHTALERT)
            return
        }
        CommonLog.LOG(massege: CommonLomMassege.TRANSIOTIONFLIGHTSEATDISPLAY)
        Router.perform(id: id + 1, to: .flightSeat, from: self)
    }
    @objc fileprivate func donePicker() {
        CommonLog.LOG(massege: CommonLomMassege.DIDSELECTPICKER)
        flightID = flightNameField.tag
        if let id = flightID {
            popoverViewController.dismiss(animated: true, completion: nil)
            flightNameField.text = presenter?.setFlightName(row: id)
            flightNameField.endEditing(true)
            presenter?.setFlightDetails(id: id)
        }
        
    }
    @objc fileprivate func cancelPicker() {
        CommonLog.LOG(massege: CommonLomMassege.CANCELSELECTPICKER)
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
        titleStackView.constraintsActive([
            titleStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.04),
            titleStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            titleStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200)
        ])
        flightInfoStackView.constraintsActive([
            flightInfoStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            flightInfoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            flightInfoStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 100)
        ])
        flightNameBackgroundView.constraintsActive([
            flightNameBackgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
        ])
        flightNameStackView.constraintsActive([
            flightNameStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            flightNameStackView.centerXAnchor.constraint(equalTo: self.flightInfoStackView.centerXAnchor),
            flightNameStackView.topAnchor.constraint(equalTo: self.flightNameBackgroundView.topAnchor, constant: 20)
        ])
        flightDetailsBackgroundView.constraintsActive([
            flightDetailsBackgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
        ])
        flightDetailsStackView.constraintsActive([
            flightDetailsStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            flightDetailsStackView.centerXAnchor.constraint(equalTo: self.flightInfoStackView.centerXAnchor),
            flightDetailsStackView.topAnchor.constraint(equalTo: self.flightDetailsBackgroundView.topAnchor, constant: 20)
        ])
        viewTransitionButton.constraintsActive([
            viewTransitionButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
            viewTransitionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            viewTransitionButton.topAnchor.constraint(equalTo: flightInfoStackView.bottomAnchor, constant: 80),
            viewTransitionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        flightDetailsTextView.constraintsActive([
            flightDetailsTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
        flightInfoStackView.spacing = 5
        flightNameStackView.spacing = 10
        flightDetailsStackView.spacing = 10
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
    // MARK: TEXT VIEW CONFIGURE
    fileprivate func textViewConfigure() {
        flightDetailsTextView.backgroundColor = .white
        flightDetailsTextView.isSelectable = false
    }
    // MARK: TOOL BAR CONFIGURE
    private func toolBarConfigure() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let doneButton = UIBarButtonItem(title: "OK", style: .done,target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain,target: self, action: #selector(cancelPicker))
        toolBar.setItems([doneButton, cancelButton], animated: false)
        return toolBar
    }
    // MARK: PICKER CONFIGURE
    fileprivate func pickerConfigure() -> UIPickerView {
        let flightPicker = UIPickerView(frame: CGRect(x: 0, y: 45, width: 320, height: 210))
        flightPicker.delegate = self
        flightPicker.dataSource = self
        return flightPicker
    }
    // MARK: textField CONFIGURE
    fileprivate func textFieldConfigure() {
        flightNameField.text = CommonFlightSelection.FLIGHTNAMEFIELDDEFAULT
        flightNameField.backgroundColor = .white
        flightNameField.tintColor = .clear
        flightNameField.delegate = self
        flightNameField.rightViewMode = .always
        flightNameField.clipsToBounds = true
        let imageView: UIImageView = UIImageView(frame: .zero)
        let image = UIImage(named: CommonImageResource.PULLDOWNBTN)
        imageView.image = image
        flightNameField.rightView = imageView
    }
    // MARK: POP OVER CONFIGURE
    fileprivate func popOverConfigure() {
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
    fileprivate func setPopOver() {
        popoverViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverViewController.popoverPresentationController?.sourceView = flightNameField
        popoverViewController.popoverPresentationController?.delegate = self
    }
    fileprivate func alert() {
        let alert = UIAlertController(title: "便名を選択してください。", message: "", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
extension FlightSelectionViewController: FlightSelectionOutput {
    public func setTextView(text: String){
        flightDetailsTextView.text = text
    }
}
extension FlightSelectionViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
       return .none
    }
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.flightNameField.endEditing(true)
    }
}
extension FlightSelectionViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setPopOver()
        self.present(popoverViewController, animated: true, completion: nil)
        return true
    }
}
extension FlightSelectionViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.flightNameField.tag = row
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.setFlightName(row: row)
    }
}
extension FlightSelectionViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.setFlightCount() ?? 0
    }
}
