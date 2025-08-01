import SwiftUI

struct ForgotPasswordSheetView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
        
            NavigationView {
                VStack(spacing: 20) {
                    Text("Reset Your Password")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("Enter your email address to receive a password reset link.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    TextField("Email Address", text: $viewModel.forgotPasswordEmail)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal)

                    if let message = viewModel.forgotPasswordMessage {
                        Text(message)
                            .foregroundColor(message.contains("Error") ? .red : .green)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        viewModel.sendPasswordResetEmail()
                    }) {
                        if viewModel.isSendingPasswordReset {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        } else {
                            Text("Send Reset Link")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(viewModel.isSendingPasswordReset)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 20)
                .navigationTitle("Forgot Password")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
        }

#Preview {
    ForgotPasswordSheetView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
