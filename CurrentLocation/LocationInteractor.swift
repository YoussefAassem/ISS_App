//
//  LocationInteractor.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation
import MapKit


protocol LocationInteractorProtocol {
    func setDelegate(_ newDelegate: LocationInteractorDelegate)
    func fetchISSLocation()
    func startTimer()
}

protocol LocationInteractorDelegate: AnyObject {
    func didFetchLocation(with location: Position)
    func didFailFetchingLocation(error: Error)
}

class LocationInteractor {
    private weak var delegate: LocationInteractorDelegate? = nil
    private let LocationService: LocationServiceProtocol
    private var timer: Timer?
    init(service: LocationServiceProtocol) {
        self.LocationService = service
    }
}

// MARK: Location Interactor Protocol Implementation

extension LocationInteractor: LocationInteractorProtocol {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(fetchISSLocation), userInfo: nil, repeats: true)
    }
    @objc func fetchISSLocation() {
        LocationService.getIssCurrentLocation(onSuccess: { position in
            self.delegate?.didFetchLocation(with: position)
        }) { error in
            self.delegate?.didFailFetchingLocation(error: error)
        }
    }

    func setDelegate(_ newDelegate: LocationInteractorDelegate) {
        delegate = newDelegate
    }
}
