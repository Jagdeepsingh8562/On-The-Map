//
//  LocationResponse.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//
struct PostLocationResponse: Codable {
    let createdAt, objectID: String

    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}
struct PutLocationResponse: Codable {
    let updatedAt: String
}
