//
//  LocationService.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/27/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation

typealias failureCallback = (Error) -> Void
typealias successCallback = (Position) -> Void
protocol LocationServiceProtocol {
    func getIssCurrentLocation(onSuccess: @escaping successCallback, onFailure: @escaping failureCallback)
}

class LocationService  : LocationServiceProtocol {
    func getIssCurrentLocation(onSuccess: @escaping successCallback, onFailure: @escaping failureCallback) {
        let defaultError: Error = NSError(domain: "", code: 1, userInfo: nil)
        guard let requestURL = URL(string: Constant.currentLocationURL) else { return }
        let request = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let dataResponse = try decoder.decode(ApiResponse.self, from: data)
                guard let currentPosition = dataResponse.issPosition else {
                    DispatchQueue.main.async {
                        onFailure(defaultError)
                    }
                    return
                }
                DispatchQueue.main.async {
                    onSuccess(currentPosition)
                }
            } catch let err {
                DispatchQueue.main.async {
                    onFailure(err)
                }
            }
        }
        task.resume()
    }
}
