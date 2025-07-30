import SwiftUI
import FirebaseAuth 

struct PasswordChangeView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    @Environment(\.dismiss) var dismiss

    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var isLoading = false

    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Change Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.loginProvider == "Google" {
                        Text("Lozinka se ne može mijenjati za Google račune. Promijenite je direktno u Google postavkama.")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                    } else {
                        PasswordInputField(
                            title: "New Password",
                            text: $newPassword,
                            showPassword: $showNewPassword
                        )

                        PasswordInputField(
                            title: "Confirm Password",
                            text: $confirmPassword,
                            showPassword: $showConfirmPassword
                        )

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }

                        if showSuccess {
                            Text("Password successfully changed.")
                                .foregroundColor(.green)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }

                        Button(action: {
                            isLoading = true
                            errorMessage = nil
                            showSuccess = false

                            viewModel.changePassword(
                                to: newPassword,
                                confirmPassword: confirmPassword,
                                onSuccess: {
                                    isLoading = false
                                    showSuccess = true
                                    newPassword = ""
                                    confirmPassword = ""
                                },
                                onError: { error in
                                    isLoading = false
                                    errorMessage = error
                                }
                            )
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            } else {
                                Text("Update Password")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(isLoading)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Change Password")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PasswordInputField: View {
    let title: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack {
            if showPassword {
                TextField(title, text: $text)
            } else {
                SecureField(title, text: $text)
            }
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PasswordChangeView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
