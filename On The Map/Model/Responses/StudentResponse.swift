//
//  StudentLocationResponse.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//

import Foundation

struct StudentResponse: Codable {
    let results: [Student]
}
//GET method
// MARK: - Result
struct Student: Codable {
    var firstName, lastName: String
    var longitude, latitude: Double
    var mapString: String
    var mediaURL: String
    var uniqueKey, objectID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, longitude, latitude, mapString, mediaURL, uniqueKey
        case objectID = "objectId"
        case createdAt, updatedAt
    }
}
