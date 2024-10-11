//
//  ContentView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct AuthWrapperView: View {
    @State private var authVM = AuthViewModel(auth: ServiceContainer.shared.authService)

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                PostsView()
            } else {
                LoginView()
            }
        }
        .environment(authVM)
    }
}

#Preview {
    AuthWrapperView()
}
