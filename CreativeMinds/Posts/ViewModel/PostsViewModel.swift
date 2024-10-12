//
//  PostsViewModel.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 12/10/2024.
//

import Foundation

@Observable class PostsViewModel {
    let db: DBService

    var posts = [Post]()
    var isLoading = false
    var errorMessage: String?

    init(db: DBService) {
        self.db = db
    }

    func addPost(from author: String, content: String) async {
        let post = Post(author: author, content: content)
        await db.addPost(post)
    }

    func fetchAllPosts() async {
        isLoading = true
        errorMessage = nil

        let result = await db.fetchAllPosts()

        switch result {
        case .success(let posts):
            self.posts = posts.sorted { $0.creationDate > $1.creationDate }
        case .failure(let err):
            errorMessage = err.errorDescription
        }

        isLoading = false
    }
}
