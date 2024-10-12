//
//  LoginView.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)

            Button {
                Task {
                    await authVM.action(email, password)
                }
            } label: {
                if authVM.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(authVM.actionButtonText)
                }
            }
            .customButtonStyle()

            Button(authVM.switchButtonText, action: authVM.switchLoginType)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel(auth: ServiceContainer.shared.authService))
}
