//
//  PostView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 12/10/2024.
//

import SwiftUI

struct PostCardView: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(PostsViewModel.self) private var postsVM

    @State var author = "User"
    let post: Post
    let fromComments: Bool

    init(post: Post, fromComments: Bool = false) {
        self.post = post
        self.fromComments = fromComments
    }

    init(author: String, post: Post, fromComments: Bool = false) {
        self.author = author
        self.post = post
        self.fromComments = fromComments
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(author)
                    .bold()

                Spacer()

                if authVM.user?.id == post.authorId {
                    Button {
                        postsVM.showDeleteAlert(from: post)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }

            Text(post.content)

            if !fromComments, let commentsCount = post.comments?.count {
                NavigationLink(destination: CommentsView(post: post, author: author)) {
                    Label("^[\(commentsCount) comment](inflect: true)", systemImage: "bubble")
                }
            }
        }
        .padding()
        .background(.white)
        .border(.regularMaterial, width: 2)
        .task {
            if let username = await postsVM.fetchUsername(for: post.authorId)  {
                author = username
            }
        }
    }
}

//#Preview {
//    PostView(authorId: "John Doe", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque orci dui, accumsan eu mauris a, tincidunt sodales libero.")
//}
