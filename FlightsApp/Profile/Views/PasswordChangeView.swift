import SwiftUI
import FirebaseAuth

struct PasswordChangeView: View {
    
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                if showSuccess {
                    Text("Password successfully changed.")
                        .foregroundColor(.green)
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
                            .frame(maxWidth: .infinity)
                            .padding()
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

                Spacer()
            }
            .padding()
            .padding(.top, 75)
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Change Password")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview{
    PasswordChangeView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
