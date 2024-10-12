//
//  AppBar.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct AppBar: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(PostsViewModel.self) private var postsVM

    var body: some View {
        HStack {
            Text("Creative Minds")

            Spacer()

            Button("Post") {
                Task {
                    guard let userId = authVM.user?.id else { return }
                    await postsVM.addPost(from: userId, content: "Hello, World!")
                }
            }
            .customButtonStyle()

            Circle()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    Task {
                        await authVM.signOut()
                    }
                }
        }
        .padding()
    }
}

#Preview {
    AppBar()
}
