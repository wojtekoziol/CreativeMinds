//
//  PostsView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct PostsView: View {
    @State private var postsVM = PostsViewModel(db: ServiceContainer.shared.dbService)

    var body: some View {
        NavigationStack {
            VStack {
                AppBar()

                ScrollView {
                    LazyVStack {
                        ForEach(postsVM.posts) { post in
                            PostView(authorId: post.authorId, content: post.content)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .refreshable {
                    await postsVM.fetchAllPosts()
                }
            }
        }
        .environment(postsVM)
        .task {
            await postsVM.fetchAllPosts()
        }
    }
}

#Preview {
    PostsView()
}
