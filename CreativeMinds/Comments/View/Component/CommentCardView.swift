//
//  CommentCardView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 21/10/2024.
//

import SwiftUI

struct CommentCardView: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(CommentsViewModel.self) private var commentsVM

    let comment: Comment

    @State private var author = "User"

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(author)
                    .bold()

                Text(comment.content)
            }

            Spacer()

            if let userId = authVM.user?.id, userId == comment.authorId {
                Button {
                    commentsVM.showDeleteAlert(comment)
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .task {
            if let username = await commentsVM.fetchUsername(for: comment.authorId) {
                author = username
            }
        }
    }
}

#Preview {
    CommentCardView(comment: Comment.preview)
}
