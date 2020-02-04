//
//  LocationFeature.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation

class LocationFeature {
    class func make<T: LocationViewFactory>(viewType: T.Type, locationService: LocationServiceProtocol = LocationService()) -> LocationCoordinator {
        let interactor: LocationInteractor = LocationInteractor(service: locationService)
        let view = T.makeView()
        let newFormatter = LocationFormatter()
        let dependencies = LocationCoordinator.Dependencies(view: view,
                                                            interactor: interactor,
                                                            formatter: newFormatter)
        return LocationCoordinator(dependencies)
    }
}
