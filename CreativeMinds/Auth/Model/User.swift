//
//  User.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let posts: [String]
}
