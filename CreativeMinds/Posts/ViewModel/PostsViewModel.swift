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
    private(set) var bannerData = BannerData.empty
    var showBanner = false

    private(set) var alertTitle = ""
    private(set) var alertMessage = ""
    var showAlert = false
    private var postToDelete: Post?

    init(db: DBService) {
        self.db = db
    }

    func addPost(from author: String, content: String) async {
        isLoading = true

        let post = Post(author: author, content: content)
        await db.addPost(post, from: author)

        isLoading = false
    }

    func fetchAllPosts() async {
        isLoading = true

        let result = await db.fetchAllPosts()

        switch result {
        case .success(let posts):
            self.posts = posts.sorted { $0.creationDate > $1.creationDate }
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }

        isLoading = false
    }

    func showDeleteAlert(from post: Post) {
        postToDelete = post
        alertTitle = "Delete post?"
        alertMessage = "This action cannot be undone."
        showAlert = true
    }

    func deletePost(userId: String) async {
        guard let postToDelete else {
            bannerData = BannerData(type: .error, title: DBError.unknown("").localizedDescription)
            showBanner = true
            return
        }

        guard postToDelete.authorId == userId else {
            bannerData = BannerData(type: .error, title: DBError.unauthorizedAccess.localizedDescription)
            showBanner = true
            return
        }

        let result = await db.deletePost(postToDelete)
        switch result {
        case .success(let postId):
            posts.removeAll { $0.id == postId }
            bannerData = BannerData(type: .success, title: "Post deleted successfully")
            showBanner = true
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }
    }

    func fetchUsername(for id: String) async -> String? {
        let result = await db.fetchUsername(for: id)
        switch result {
        case .success(let username):
            return username
        case .failure(let err):
            print("\(err.debugDescription) - PostsVM - fetchUsername(id: \(id))")
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
            return nil
        }
    }
}
