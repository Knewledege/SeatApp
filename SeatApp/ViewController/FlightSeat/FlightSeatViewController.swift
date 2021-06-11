//
//  FlightSeatViewController.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/13.
//  Copyright © 2021 k-takahashi. All rights reserved.
//
import UIKit
public class FlightSeatViewController: UIViewController {
    @IBOutlet private weak var seatScrollView: UIScrollView!
    // カスタムレイアウト
    @IBOutlet private weak var customContentView: CustumContentsView!
    // プレゼンター
    private var presenter: FlightSeatInput?
    // 便ID
    internal var flightID: Int = 0
    // セルカスタムレイアウト

    override public func viewDidLoad() {
        super.viewDidLoad()
        CommonLog.LOG(massege: "")
        presenter = FlightSeatPresenter(delegate: self)
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        // 座席編集ボタン設定
        setRightBarButtonItem()

        seatScrollView.delegate = self
        seatScrollView.maximumZoomScale = 8.0
        seatScrollView.minimumZoomScale = 1.0

        customContentView.contentViewConfigure(seatRows: self.presenter?.getSeatRow(id: flightID) ?? 0, seatColumns: self.presenter?.getSeatColumn() ?? 0, screenWidth: UIScreen.main.bounds.width)

        seatScrollView.contentSize = customContentView.seatViewContentSize
    }
     override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonLog.LOG(massege: "")
        // 便名をプレゼンターに依頼
        presenter?.getFlightName(id: flightID)
        let seatNumber = self.presenter?.getAllSeatNumber() ?? [[CellType.passCell]]
        let seatName = self.presenter?.getAllSeatName() ?? [[Common.NOCUTMERNAME]]
        customContentView.setContent(seatNumber: seatNumber, seatName: seatName)
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
extension FlightSeatViewController: UIScrollViewDelegate {
    /// ズーム対象を設定
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        customContentView
    }
    /// ズームしたら座席行・列表示欄を端に固定
    /// scrollView.zoomScaleで割ってる理由は拡大縮小際の比率を与えないと、スクロール量にズレが生じるため
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y / scrollView.zoomScale
        let offsetX = scrollView.contentOffset.x / scrollView.zoomScale
        customContentView.dummyView.frame.origin = CGPoint(x: offsetX, y: offsetY)
        customContentView.topContentViews.forEach { topContent in
            topContent.frame.origin.y = offsetY
        }
        customContentView.leftContentViews.forEach { leftContent in
            leftContent.frame.origin.x = offsetX
        }
    }
}
