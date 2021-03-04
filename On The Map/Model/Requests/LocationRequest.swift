//
//  LocationRequest.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//

struct LocationRequest: Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}
