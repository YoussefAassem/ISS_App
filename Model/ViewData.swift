//
//  ViewData.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/28/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import Foundation



struct Position: Codable {
    let latitude: String?
    let longitude: String?
}

struct ApiResponse: Codable {
    let message: String?
    let timestamp: Int?
    let issPosition: Position?
    
    enum CodingKeys: String, CodingKey {
        case issPosition = "iss_position"
        case message = "message"
        case timestamp = "timestamp"
    }
}
