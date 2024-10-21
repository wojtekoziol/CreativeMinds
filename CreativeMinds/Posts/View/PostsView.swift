//
//  PostsView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct PostsView: View {
    @Environment(AuthViewModel.self) private var authVM

    @State private var postsVM = PostsViewModel(db: ServiceContainer.shared.dbService)

    var body: some View {
        NavigationStack {
            VStack {
                AppBar()

                ScrollView {
                    LazyVStack {
                        if postsVM.posts.isEmpty {
                            Text("No posts to show")
                                .foregroundStyle(.secondary)
                                .padding(.top)
                        }

                        ForEach(postsVM.posts) { post in
                            PostCardView(post: post)
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
        .banner(show: $postsVM.showBanner, with: postsVM.bannerData)
        .alert(postsVM.alertTitle, isPresented: $postsVM.showAlert) {
            Button("Delete", role: .destructive) {
                guard let userId = authVM.user?.id else { return }
                Task {
                    await postsVM.deletePost(userId: userId)
                }
            }

            Button("Cancel", role: .cancel) { }
        } message: {
            Text(postsVM.alertMessage)
        }

    }
}

#Preview {
    PostsView()
}
