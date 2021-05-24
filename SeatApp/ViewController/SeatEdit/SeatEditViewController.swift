//
//  SeatEditViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import UIKit

public class SeatEditViewController: UIViewController {
    @IBOutlet weak var seatEditCollectionView: UICollectionView!
    private var presenter: SeatEditInput?
    internal var flightID: Int = 0
    fileprivate var changeSeat: Bool = false
    let layout = CollectionViewLayout()
    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = SeatEditPresenter(delegate: self)
        presenter?.getFlightName(id: flightID)
        setRightBarButtonItem()
        layout.cellWidth = (UIScreen.main.bounds.width - 30) / (CGFloat(self.presenter?.getSeatColumn() ?? 0) - 1)
        seatEditCollectionView.collectionViewLayout = layout
        seatEditCollectionView.register(UINib(nibName: FlightSeatCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FlightSeatCollectionViewCell.className)
               seatEditCollectionView.register(UINib(nibName: FlightItemNumberCollectionViewCell.className, bundle: nil), forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className)
        seatEditCollectionView.dataSource = self
        seatEditCollectionView.delegate = self
        seatEditCollectionView.dropDelegate = self
        seatEditCollectionView.dragDelegate = self
        seatEditCollectionView.dragInteractionEnabled = true
    }
    override public func viewWillAppear(_ animated: Bool) {
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
    //  MARK: SET BAR BUTTON ITEM
    private func setRightBarButtonItem() {
        let okButton: UIButton = UIButton(type: .custom)
        okButton.buttonConfigure(imageName: CommonImageResource.OKBTN, target: self, action: #selector(doneEdit))
        let cancelButton: UIButton = UIButton(type: .custom)
        cancelButton.buttonConfigure(imageName: CommonImageResource.CANCELBTN, target: self, action: #selector(cancelEdit))

        let okBarItem = UIBarButtonItem(customView: okButton)
        let cancelBarItem = UIBarButtonItem(customView: cancelButton)

        okBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
        cancelBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
        self.navigationItem.rightBarButtonItems = [cancelBarItem, okBarItem]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc private func doneEdit() {
        CommonLog.LOG(massege: CommonLomMassege.DONEEDITBUTTON)
        if self.changeSeat {
            self.presenter?.updateSeatData()
            CommonLog.LOG(massege: CommonLomMassege.SEATUPDATE)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func cancelEdit() {
        CommonLog.LOG(massege: CommonLomMassege.CANCELSEATEDITBUTTON)
        if self.changeSeat {
            let alert = UIAlertController(title: "座席の編集を破棄しますがよろしいですか？", message: "", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "はい", style: .default, handler:{ (action: UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: .default, handler:nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion:{
              CommonLog.LOG(massege: CommonLomMassege.SEATEDITBUTTONCANCELALERT)
            })
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension SeatEditViewController: SeatEditOutput {
    func setLeftBarButtonItem(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: .none, action: .none)
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
}
// MARK: - UICollectionViewDataSource
extension SeatEditViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter?.getSeatRow(id: flightID) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter?.getSeatColumn() ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightSeatCollectionViewCell.className, for: indexPath) as? FlightSeatCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else{
          return cell
        
        }
        if indexPath.section == 0 || indexPath.row == 0{
            cell.cellBackgroundColor(color: UIColor.init(rgb: CommonColor.MAINCOLOR))
        }else{
            cell.cellBackgroundColor(color: .white)
        }
        cell.imageConfigure(name: seatImage)
        cell.rowLabelConfigure(text: seatName)

        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryCell = collectionView.dequeueReusableSupplementaryView(ofKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className, for: indexPath) as? FlightItemNumberCollectionViewCell else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 || indexPath.row == 0{
              guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else{
                  return supplementaryCell
                
                }
                if indexPath.section == 0 || indexPath.row == 0{
                    supplementaryCell.cellBackgroundColor(color: UIColor.init(rgb: CommonColor.MAINCOLOR))
                }else{
                    supplementaryCell.cellBackgroundColor(color: .white)
                }
                supplementaryCell.imageConfigure(name: seatImage)
                supplementaryCell.rowLabelConfigure(text: seatName)
        }
        return supplementaryCell
    }
}

// MARK: - UICollectionViewDelegate
extension SeatEditViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }

}

extension SeatEditViewController: UICollectionViewDropDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let item = coordinator.items.first,
               let destinationIndexPath = coordinator.destinationIndexPath,
               let sourceIndexPath = item.sourceIndexPath else { return }
        self.presenter?.resetCellInfo(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
           collectionView.performBatchUpdates({ [weak self] in
               guard let strongSelf = self else { return }
               collectionView.reloadItems(at: [sourceIndexPath])
               collectionView.reloadItems(at: [destinationIndexPath])
               }, completion: nil)
           coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        self.changeSeat = true
        CommonLog.LOG(massege: CommonLomMassege.SEATDROP)
    }

    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let indexPath = destinationIndexPath else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        if let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row) {
            if seatImage != "seat" {
                return UICollectionViewDropProposal(operation: .cancel)
            }
        }
        return UICollectionViewDropProposal(operation: .move, intent: .unspecified)

    }
}
extension SeatEditViewController: UICollectionViewDragDelegate{
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        CommonLog.LOG(massege: CommonLomMassege.SEATDRAGSTART)
        if indexPath.section == 0 || indexPath.row == 0{
            return []
        }
        guard let seatImage = self.presenter?.getSeatNumber(section: indexPath.section, row: indexPath.row),let seatName = self.presenter?.getSeatName(section: indexPath.section, row: indexPath.row)  else{
            return []
        }
        if seatImage == "none" || seatImage == "seat" {
            return []
        }
        if let seat = UIImage(named: seatImage) {
            let itemProvider = NSItemProvider(object: seat)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        }
        return []
    }
}
