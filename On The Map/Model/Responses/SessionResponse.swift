//
//  SessionResponse.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}
