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
    let author: String
    let content: String
    let creationDate: Double

    init(author: String, content: String) {
        self.author = author
        self.content = content
        self.creationDate = Date.now.timeIntervalSince1970
    }
}
