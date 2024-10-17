//
//  PostView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 12/10/2024.
//

import SwiftUI

struct PostView: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(PostsViewModel.self) private var postsVM

    @State var author = "User"
    let authorId: String
    let content: String

    var body: some View {
        VStack(alignment: .listRowSeparatorLeading, spacing: 10) {
            HStack {
                Text(author)
                    .bold()

                Spacer()
            }

            Text(content)
        }
        .padding()
        .background(.white)
        .border(.regularMaterial, width: 2)
        .task {
            if let userId = authVM.user?.id, let username = await postsVM.fetchUsername(for: userId)  {
                author = username
            }
        }
    }
}

//#Preview {
//    PostView(authorId: "John Doe", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque orci dui, accumsan eu mauris a, tincidunt sodales libero.")
//}
