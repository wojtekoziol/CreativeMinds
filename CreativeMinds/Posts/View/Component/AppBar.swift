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

            if let userId = authVM.user?.id {
                NavigationLink(destination: NewPostView()) {
                    Text("Post")
                        .customButtonStyle()
                }
            }

            NavigationLink(destination: ProfileView()) {
                Circle()
                    .fill(.graphite)
                    .frame(width: 40)                    
            }
        }
        .padding()
    }
}

#Preview {
    AppBar()
}
