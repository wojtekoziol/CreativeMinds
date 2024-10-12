//
//  PostView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 12/10/2024.
//

import SwiftUI

struct PostView: View {
    let author: String
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
        .clipped()
        .shadow(radius: 5)
    }
}

#Preview {
    PostView(author: "John Doe", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque orci dui, accumsan eu mauris a, tincidunt sodales libero.")
}
