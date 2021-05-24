//
//  Router.swift
//  SeatApp
//
//  Created by 高橋慧 on 2021/05/18.
//  Copyright © 2021 k-takahashi. All rights reserved.
//

import Foundation
import UIKit
enum Board {

    case flightSeat
    case seatEdit
    
    var identifer: String{
        switch self {
        case .flightSeat: return "FlightSeatViewController"
        case .seatEdit:   return "SeatEditViewController"
        }
    }
    
    func boardInit(id: Int) -> UIViewController?{
        switch self {
        case .flightSeat:
            let nextVC = UIStoryboard(name: "FlightSeat", bundle: nil).instantiateViewController(withIdentifier: self.identifer) as? FlightSeatViewController
            nextVC?.flightID = id
            return nextVC
        case .seatEdit:
            let nextVC = UIStoryboard(name: "SeatEdit", bundle: nil).instantiateViewController(withIdentifier: self.identifer) as? SeatEditViewController
            nextVC?.flightID = id
            return nextVC
        }
    }
}

final class Router{
    //    MARK: - Screen Transition　画面遷移
    /// - Parameters:
    ///   - id :FlightID
    ///   - to:遷移先のViewController
    ///   - from:遷移元のViewController
    ///Show遷移
    static func perform(id:Int, to:Board, from:UIViewController){
        if let nextVC = to.boardInit(id: id){
            from.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    deinit {
          print("storyboard", #function)
    }
}
