//
//  AppBar.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct AppBar: View {
    var body: some View {
        HStack {
            Text("Creative Minds")

            Spacer()

            Button("Post") {
                
            }
            .customButtonStyle()

            Circle()
                .frame(width: 40, height: 40)
        }
        .padding()
    }
}

#Preview {
    AppBar()
}
