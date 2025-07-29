import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    @State private var isFaceIDEnabled: Bool = false

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)

            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white.opacity(0.8))
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))

                        VStack(alignment: .leading) {
                            Text(viewModel.username ?? viewModel.email.components(separatedBy: "@").first ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Logged in")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Button(action: {
                            viewModel.newUsernameInput = viewModel.username ?? ""
                            viewModel.usernameUpdateErrorMessage = nil
                            viewModel.showEditProfileSheet = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color(red: 25/255, green: 80/255, blue: 200/255))
                    .cornerRadius(15)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.leading)

                        NavigationLink(destination: MyAccountDetailsView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))) {
                            ProfileOptionRowView(icon: "person.fill", title: "My Account", subtitle: "See your account details", showChevron: true, showToggle: false, toggleState: .constant(false))
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            viewModel.handleChangePassword {
                                viewModel.alertTitle = "Not Allowed"
                                viewModel.alertMessage = "You signed in using Google. Password change is not allowed."
                                viewModel.showAlert = true
                            }
                        }) {
                            ProfileOptionRowView(icon: "lock.fill", title: "Change Password", subtitle: "Update your password", showChevron: true, showToggle: false, toggleState: .constant(false))
                        }
                        .buttonStyle(PlainButtonStyle())

                        ProfileOptionRowView(icon: "faceid", title: "Face ID / Touch ID", subtitle: "Manage your device security", showChevron: false, showToggle: true, toggleState: $isFaceIDEnabled) {
                            print("Face ID toggle changed to \(isFaceIDEnabled)")
                        }
                        
                        Button(action: { viewModel.logout() }) {
                            ProfileOptionRowView(icon: "arrow.right.square.fill", title: "Log out", subtitle: "Log out from the application", showChevron: true, showToggle: false, toggleState: .constant(false))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Support")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.leading)

                        NavigationLink(destination: FAQScreenView()) {
                            ProfileOptionRowView(icon: "questionmark.circle.fill", title: "Frequently Asked Questions (FAQ)", subtitle: "Answers to common questions", showChevron: true, showToggle: false, toggleState: .constant(false))
                          
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Profile")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $viewModel.showEditProfileSheet) {
            EditProfileSheetView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $viewModel.navigateToChangePassword) {
            PasswordChangeView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.showEditProfileSheet) { oldValue, newValue in
            if oldValue && !newValue {
                if let uid = viewModel.dataManager.currentUserID {
                    viewModel.fetchUsername(for: uid)
                }
            }
        }
    }
}

#Preview {
    ProfileScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
