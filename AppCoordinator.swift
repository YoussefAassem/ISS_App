//
//  AppCoordinator.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import UIKit

class AppCoordinator
{
    private var window: UIWindow
    private var locationCoordinator: LocationCoordinator
    init(window: UIWindow) {
        self.window = window
        locationCoordinator = LocationFeature.make(viewType: StationLocationViewController.self)
    }
    func start() {
        let view = locationCoordinator.start()
        guard let unwrappedView = view else { return }
        window.rootViewController = unwrappedView
    }
}
