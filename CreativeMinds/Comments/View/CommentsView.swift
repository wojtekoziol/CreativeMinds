//
//  CommentsView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 21/10/2024.
//

import SwiftUI

struct CommentsView: View {
    @Environment(AuthViewModel.self) private var authVM

    @State private var commentsVM: CommentsViewModel
    @State private var content = ""

    let author: String
    let post: Post

    init(post: Post, author: String) {
        self.post = post
        self.author = author

        self._commentsVM = State(initialValue: CommentsViewModel(post: post, db: ServiceContainer.shared.dbService))
    }

    var body: some View {
        VStack(spacing: 0) {
            PostCardView(author: author, post: post, fromComments: true)

            HStack(spacing: 0) {
                TextField("Comment",
                          text: $content,
                          prompt: Text("Your comment goes here...").foregroundStyle(.white.opacity(0.5)))
                .customTextFieldStyle()

                Button("Comment") {
                    guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let userId = authVM.user?.id else { return }

                    let comment = Comment(authorId: userId, content: content)
                    Task {
                        if await commentsVM.addComment(comment) { 
                            content = ""
                        }
                    }
                }
                .customButtonStyle()
            }

            List {
                ForEach(commentsVM.comments) { comment in
                    CommentCardView(comment: comment)
                        .environment(commentsVM)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("\(author)'s post")
        .navigationBarTitleDisplayMode(.inline)
        .banner(show: $commentsVM.showBanner, with: commentsVM.bannerData)
        .alert(commentsVM.alertTitle, isPresented: $commentsVM.showAlert) {
            Button("Delete", role: .destructive) {
                Task { await commentsVM.deleteComment() }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(commentsVM.alertMessage)
        }

    }
}

//#Preview {
//    NavigationStack {
//        CommentsView(post: Post.preview, author: "John Doe")
//    }
//}
