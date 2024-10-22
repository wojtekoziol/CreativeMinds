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

            CircularProfilePicture(image: profileVM.profilePicture, size: 100, isLoading: profileVM.isLoading) { item in
                Task {
                    await verifyUser { userId in
                        guard let imageData = try? await item.loadTransferable(type: Data.self) else { return }
                        await profileVM.uploadProfilePicture(imageData, for: userId)
                    }
                }
            }

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
            await verifyUser { userId in
                await profileVM.fetchUsername(for: userId)
            }
        }
        .task {
            await verifyUser { userId in
                await profileVM.downloadProfilePicture(for: userId)
            }
        }
        .banner(show: $profileVM.showBanner, with: profileVM.bannerData)
    }

    private func verifyUser(completion: (_ userId: String) async -> Void) async {
        if let userId = authVM.user?.id {
            await completion(userId)
        } else {
            dismiss()
        }
    }
}

//#Preview {
//    ProfileView()
//}
