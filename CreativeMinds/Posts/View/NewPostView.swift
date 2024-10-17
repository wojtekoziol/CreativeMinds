//
//  NewPostView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 13/10/2024.
//

import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authVM
    @Environment(PostsViewModel.self) private var postsVM

    @State private var content = ""

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Spacer()

            Text("Create. Post. Share.")
                .font(.title)

            Text("Let's create a new post!")

            Spacer()

            TextField("Post content",
                      text: $content,
                      prompt: Text("Your content goes here...").foregroundStyle(.white.opacity(0.5)),
                      axis: .vertical)
            .lineLimit(15, reservesSpace: true)
            .customTextFieldStyle()

            Button {
                if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
                guard let userId = authVM.user?.id else { return }
                
                Task {
                    await postsVM.addPost(from: userId, content: content)
                    dismiss()
                    await postsVM.fetchAllPosts()
                }
            } label: {
                if postsVM.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Post")
                }
            }
            .frame(maxWidth: .infinity)
            .customButtonStyle()

            Spacer()
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    NewPostView()
//}
