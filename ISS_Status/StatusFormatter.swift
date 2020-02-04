//
//  StatusFormatter.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//
import UIKit.UIColor

enum StationState: String {
    case initialState = "Waiting for the information ..."
    case isAbove = "The station is above the user"
    case isNotAbove = "The station is not above the user "
}

class StatusFormatter {
    func getColor(for state: StationState) -> (UIColor,String) {
        var color: UIColor = Constant.defaultColor
        color = (state == .isAbove) ? .green : .red
        return (color, state.rawValue)
    }
}
