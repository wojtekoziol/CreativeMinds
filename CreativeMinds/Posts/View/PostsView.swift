//
//  PostsView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct PostsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AppBar()

                ScrollView {
                    Text("Hello World")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    PostsView()
}
