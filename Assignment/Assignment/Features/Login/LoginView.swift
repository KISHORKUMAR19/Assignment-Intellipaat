//
//  LoginView.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.username)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        Task { await viewModel.login() }
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("Login")
                            }
                            Spacer()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                Section {
                    Text("Demo: any valid email and 6+ character password. Use kishor@test.com to see a login error.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Login")
        }
    }
}
