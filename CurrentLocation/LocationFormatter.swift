//
//  LocationFormatter.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import MapKit

class LocationFormatter {
    func prepare(position: Position) -> CLLocation? {
        guard let latitude = position.latitude, let longitude = position.longitude else {
            return nil
        }
        guard let lat = CLLocationDegrees(latitude), let long = CLLocationDegrees(longitude) else {
            return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }
}

