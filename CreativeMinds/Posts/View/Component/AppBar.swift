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

    @State private var image: UIImage?

    var body: some View {
        HStack {
            Text("Creative Minds")

            Spacer()

            if authVM.user?.id != nil {
                NavigationLink(destination: NewPostView()) {
                    Text("Post")
                        .customButtonStyle()
                }
            }

            NavigationLink(destination: ProfileView()) {
                CircularProfilePicture(image: image, size: 40)
            }
        }
        .padding()
        .task {
            guard let userId = authVM.user?.id else { return }
            image = await postsVM.downloadProfilePicture(for: userId)
        }
    }
}

#Preview {
    AppBar()
}
