//
//  StatusFeature.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation

class StatusFeature {
    static func makeStatusCoordinator<T: StatusViewFactory>(viewType: T.Type, statusService: StatusServiceProtocol = StatusService()) -> StatusCoordinator {
        let newView = T.makeView()
        let interactor = StatusInteractor(newService: statusService)
        let newFormatter = StatusFormatter()
        let dependencies = StatusCoordinator.Dependencies(view: newView, interactor: interactor,formatter: newFormatter)
        return StatusCoordinator(dependencies)
    }
}
