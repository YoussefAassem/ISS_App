//
//  LocationCoordinator.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import UIKit


class LocationCoordinator {
    struct Dependencies {
        var view: LocationViewProtocol
        let interactor: LocationInteractorProtocol
        let formatter: LocationFormatter
    }
    private var deps: Dependencies
    private var statusCoordinator: StatusCoordinator? = nil
    
    init(_ dependencies: Dependencies) {
        self.deps = dependencies
        deps.view.setDelegate(self)
        deps.interactor.setDelegate(self)
    }
    
    func start() -> UIViewController? {
        deps.interactor.startTimer()
        let viewController = deps.view as? UIViewController
        return viewController
    }
}

extension LocationCoordinator: LocationViewDelegate {
    func viewIsReady() {
        if statusCoordinator == nil {
            statusCoordinator = StatusFeature.makeStatusCoordinator(viewType: StatusView.self)
        }
        guard let statusView = statusCoordinator?.start() else { return }
        deps.view.addSubView(statusView)
    }
}


extension LocationCoordinator: LocationInteractorDelegate {
    func didFailFetchingLocation(error: Error) {
        deps.view.showError(message: error.localizedDescription)
    }
    func didFetchLocation(with location: Position) {
        let viewData = deps.formatter.prepare(position: location)
        guard let position = viewData else {
            deps.view.showError(message: Constant.Errors.dataError)
            return
        }
        deps.view.updateUI(with: position)
        statusCoordinator?.updateLocation(newLocation: position)
    }
}
 
