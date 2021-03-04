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
    let firstName, lastName: String
    let longitude, latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey, objectID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, longitude, latitude, mapString, mediaURL, uniqueKey
        case objectID = "objectId"
        case createdAt, updatedAt
    }
}
