//
//  StatusService.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation
import MapKit

protocol UserServiceDelegate: AnyObject {
    func didFetchUserPosition(_ location: CLLocation)
    func didFailWithError(_ error: Error)
}
protocol StatusServiceProtocol {
    func getUserLocation(_ issLocationProvided: Bool)
    func setDelegate(_ newDelegate: UserServiceDelegate)
}

class StatusService: NSObject {
    private let locationManager: CLLocationManager =  CLLocationManager()
    private weak var delegate: UserServiceDelegate?
    override init() {
        super.init()
        locationManager.delegate = self
     }
}

extension StatusService: StatusServiceProtocol {

    func getUserLocation(_ issLocationProvided: Bool = false) {
       guard issLocationProvided == true else { return }
       requestPermissions()
       let status = CLLocationManager.authorizationStatus()
       if status == .denied || status == .restricted {
            return
        }
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.requestLocation()
    }

    func setDelegate(_ newDelegate: UserServiceDelegate) {
        delegate = newDelegate
    }
}

private extension StatusService {
    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
}


extension StatusService: CLLocationManagerDelegate {
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       getUserLocation()
       }
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentPosition = locations.first else { return }
        delegate?.didFetchUserPosition(currentPosition)
       }
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error)
       }
    
}

