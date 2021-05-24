//
//  FlightSeatViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//
import UIKit
public class FlightSeatViewController: UIViewController {

    @IBOutlet weak var flightSeatCollectionView: UICollectionView!
    private var presenter: FlightSeatInput?
    internal var flightID: Int = 0
    let layout = CollectionViewLayout()
    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = FlightSeatPresenter(delegate: self)
        presenter?.getFlightName(id: flightID)
        setRightBarButtonItem()
        layout.cellWidth = (UIScreen.main.bounds.width - 30) / (CGFloat(self.presenter?.getSeatColumn() ?? 0) - 1)
        flightSeatCollectionView.collectionViewLayout = layout
        flightSeatCollectionView.register(UINib(nibName: FlightSeatCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: FlightSeatCollectionViewCell.className)
        flightSeatCollectionView.register(UINib(nibName: FlightItemNumberCollectionViewCell.className, bundle: nil), forSupplementaryViewOfKind: FlightItemNumberCollectionViewCell.className, withReuseIdentifier: FlightItemNumberCollectionViewCell.className)
        flightSeatCollectionView.dataSource = self
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchCell))
        flightSeatCollectionView.addGestureRecognizer(pinch)
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
         let editButton: UIButton = UIButton(type: .custom)
         editButton.buttonConfigure(imageName: CommonImageResource.EDITBTN, target: self, action: #selector(pushDisplay))
         let editBarItem = UIBarButtonItem(customView: editButton)

         editBarItem.constraintsConfigure(widthCnstant: 100, heightConstant: 30)
         self.navigationItem.rightBarButtonItem = editBarItem
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func pinchCell(_ sender: UIPinchGestureRecognizer){
        layout.cellWidth = (layout.cellWidth * sender.scale)
        flightSeatCollectionView.reloadData()
    }
    @objc func popDisplay() {
        CommonLog.LOG(massege: CommonLomMassege.BACKFLIGHTSELECTDISPLAY)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func pushDisplay() {
        CommonLog.LOG(massege: CommonLomMassege.TRANSIOTIONSEATEDITDISPLAY)
        Router.perform(id: flightID, to: .seatEdit, from: self)
    }
}
extension FlightSeatViewController: FlightSeatOutput {
    func setLeftBarButtonItem(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popDisplay))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
}
// MARK: - UICollectionViewDataSource
extension FlightSeatViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter?.getSeatRow(id: flightID) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter?.getSeatColumn() ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightSeatCollectionViewCell.className, for: indexPath) as? FlightSeatCollectionViewCell else {
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
                supplementaryCell.cellBackgroundColor(color: UIColor.init(rgb: CommonColor.MAINCOLOR))
                supplementaryCell.imageConfigure(name: seatImage)
                supplementaryCell.rowLabelConfigure(text: seatName)
        }else{
            supplementaryCell.cellBackgroundColor(color: .white)
        }
        return supplementaryCell
    }
}
