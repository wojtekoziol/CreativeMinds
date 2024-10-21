//
//  Comment.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 21/10/2024.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String
    let authorId: String
    let content: String
    let creationDate: Double

    init(authorId: String, content: String) {
        self.id = UUID().uuidString
        self.authorId = authorId
        self.content = content
        self.creationDate = Date.now.timeIntervalSince1970
    }

    static let preview = Comment(authorId: UUID().uuidString, content: "Hello, World!")
}
