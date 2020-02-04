//
//  StatusInteractor.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import MapKit


protocol StatusInteractorDelegate: AnyObject{
    func didDetermineCurrentStatus(_ newStatus: StationState)
    func didFailWithError(_ error: Error)
}

class StatusInteractor {
    
    private weak var delegate: StatusInteractorDelegate?
    private let service: StatusServiceProtocol
    private var currentISSLocation: CLLocation? {
        didSet {
            guard currentISSLocation != nil else { return }
            getUserLocation()
        }
    }
    
    init(newService: StatusServiceProtocol) {
        service = newService
        service.setDelegate(self)
    }
    
    func updateCurrentISSLocation(with newLocation: CLLocation) {
        currentISSLocation = newLocation
    }
    func setDelegate(_ newDelegate: StatusInteractorDelegate) {
        delegate = newDelegate
    }
}

//MARK: Private functions
private extension StatusInteractor {
    func getDistance(from userLocation: CLLocation,to issLocation: CLLocation) -> CLLocationDistance {
         return userLocation.distance(from: issLocation) 
    }
    func getISSCurrentStatus(for distance: Double)  {
        let currentStatus: StationState = (distance <= 10 ) ? .isAbove : .isNotAbove
        delegate?.didDetermineCurrentStatus(currentStatus)
    }
    func getUserLocation() {
        service.getUserLocation(true)
    }
}
//MARK: UserService Delegate
extension StatusInteractor: UserServiceDelegate {
    
    func didFailWithError(_ error: Error) {
        delegate?.didFailWithError(error)
    }
    func didFetchUserPosition(_ location: CLLocation) {
        guard let issLocation = currentISSLocation else {
            let error = NSError(domain: "Data nil", code: -1, userInfo: nil)
            delegate?.didFailWithError(error)
            return
        }
      let distance = getDistance(from: issLocation, to: location)
      getISSCurrentStatus(for: distance)
    }
}
