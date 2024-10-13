//
//  User.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import FirebaseFirestore
import Foundation

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let username: String
    let posts: [String]
}
