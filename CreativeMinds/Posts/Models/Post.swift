//
//  Post.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 12/10/2024.
//

import FirebaseFirestore
import Foundation

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    let authorId: String
    let content: String
    let creationDate: Double
    let comments: [Comment]?

    init(author: String, content: String) {
        self.authorId = author
        self.content = content
        self.creationDate = Date.now.timeIntervalSince1970
        self.comments = []
    }

    private init(authorId: String, content: String, comments: [Comment]) {
        self.authorId = authorId
        self.content = content
        self.creationDate = Date.now.timeIntervalSince1970
        self.comments = comments
    }

    var commentsExtracted: [Comment] {
        comments ?? []
    }

    static let preview = Post(authorId: UUID().uuidString, content: "Hello, World!", comments: [Comment(authorId: UUID().uuidString, content: "Nice post :)")])
}
