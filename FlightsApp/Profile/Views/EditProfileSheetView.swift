import SwiftUI

struct EditProfileSheetView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Edit Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Username")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.leading)

                        TextField("Enter new username", text: $viewModel.newUsernameInput)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    if let errorMessage = viewModel.usernameUpdateErrorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }

                    Button {
                        viewModel.updateUsername()
                    } label: {
                        if viewModel.isUpdatingUsername { 
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        } else {
                            Text("Save changes")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(viewModel.isUpdatingUsername || viewModel.newUsernameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit profile")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .onChange(of: viewModel.showEditProfileSheet) { oldValue, newValue in
                if !newValue { 
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditProfileSheetView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
