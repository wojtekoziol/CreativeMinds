//
//  CommentsViewModel.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 21/10/2024.
//

import Foundation

@Observable class CommentsViewModel {
    let post: Post
    let db: DBService

    var comments: [Comment]

    private(set) var bannerData = BannerData.empty
    var showBanner = false

    private(set) var alertTitle = ""
    private(set) var alertMessage = ""
    var showAlert = false
    private var commentToDelete: Comment?

    init(post: Post, db: DBService) {
        self.post = post
        self.db = db
        self.comments = post.commentsExtracted
        sortComments()
    }

    func addComment(_ comment: Comment) async -> Bool {
        guard let postId = post.id else {
            bannerData = BannerData(type: .error, title: DBError.unauthorizedAccess.localizedDescription)
            showBanner = true
            return false
        }

        let result = await db.addComment(comment, to: postId)
        switch result {
        case .success(let comment):
            comments.append(comment)
            sortComments()
            return true
        case .failure(let err):
            debugPrint("CommentsViewModel - addComment(comment: \(comment)) - \(err.debugDescription)")
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
            return false
        }
    }

    func showDeleteAlert(_ comment: Comment) {
        commentToDelete = comment
        alertTitle = "Delete comment?"
        alertMessage = "This action cannot be undone."
        showAlert = true
    }

    func deleteComment() async {
        guard let commentToDelete, let postId = post.id else {
            bannerData = BannerData(type: .error, title: DBError.unauthorizedAccess.localizedDescription)
            showBanner = true
            return
        }

        let result = await db.deleteComment(commentToDelete, from: postId)
        switch result {
        case .success(let deletedCommentId):
            comments.removeAll { $0.id == deletedCommentId }

            bannerData = BannerData(type: .success, title: "Comment deleted")
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
            print("\(err.debugDescription) - CommentsVM - fetchUsername(id: \(id))")
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
            return nil
        }
    }

    private func sortComments() {
        comments.sort { $0.creationDate > $1.creationDate }
    }
}
