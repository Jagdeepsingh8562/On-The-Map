//
//  UserResponse.swift
//  On The Map
//
//  Created by Jagdeep Singh on 11/03/21.
//

import Foundation
struct UserResponse: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}
