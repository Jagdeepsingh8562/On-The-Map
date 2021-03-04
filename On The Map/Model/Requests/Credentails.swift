//
//  Credentails.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//
struct Credentails: Codable {
    let udacity: Udacity
}
// MARK: - Udacity
struct Udacity: Codable {
    let username, password: String
}

