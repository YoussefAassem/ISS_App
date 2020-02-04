//
//  StatusCoordinator.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation
import MapKit

class StatusCoordinator {
    
    struct Dependencies {
        var view: StatusViewProtocol
        let interactor: StatusInteractor
        let formatter: StatusFormatter
    }
    
    private var deps: Dependencies
    
    init(_ dependencies: Dependencies) {
        deps = dependencies
        deps.interactor.setDelegate(self)
    }
    
    func updateLocation(newLocation: CLLocation){
        deps.interactor.updateCurrentISSLocation(with: newLocation)
    }
    
    func start() -> UIView?  {
        guard let view = deps.view as? UIView else { return nil}
        return view
    }

}

extension StatusCoordinator: StatusInteractorDelegate {
    func didDetermineCurrentStatus(_ newStatus: StationState) {
        let tuple = deps.formatter.getColor(for: newStatus)
        deps.view.updateState(with: tuple.0, text: tuple.1)
    }

    func didFailWithError(_ error: Error) {
        deps.view.showError(error.localizedDescription)
    }
}
