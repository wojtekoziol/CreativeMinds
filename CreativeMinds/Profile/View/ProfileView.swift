//
//  ProfileView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 13/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authVM
    @Environment(PostsViewModel.self) private var postsVM

    @State private var profileVM = ProfileViewModel(db: ServiceContainer.shared.dbService)

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Circle()
                .fill(.graphite)
                .frame(width: 100)

            Spacer()

            TextField("Username", text: $profileVM.username, prompt: Text("Username").foregroundStyle(.white.opacity(0.5)))
                .customTextFieldStyle()

            Button("Update username") {
                Task {
                    guard let userId = authVM.user?.id else { return }
                    await profileVM.updateUsername(for: userId)
                }
            }
            .frame(maxWidth: .infinity)
            .customButtonStyle()

            Spacer()
            Spacer()
            Spacer()

            Button("Sign Out") {
                Task {
                    await authVM.signOut()
                }
            }
            .customButtonStyle()
        }
        .padding()
        .task {
            if let userId = authVM.user?.id {
                await profileVM.fetchUsername(for: userId)
            } else {
                dismiss()
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
