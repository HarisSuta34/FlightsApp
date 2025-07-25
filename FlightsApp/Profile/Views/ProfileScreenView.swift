import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    @State private var isFaceIDEnabled: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white.opacity(0.8))
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))

                            VStack(alignment: .leading) {
                                Text(viewModel.email.isEmpty ? "User" : viewModel.email)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Logged in")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            Button(action: {
                                print("Edit profile tapped")
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

                            Button(action: { print("My Account tapped") }) {
                                ProfileOptionRowView(icon: "person.fill", title: "My Account", subtitle: "Edit your details", showChevron: true, showToggle: false, toggleState: .constant(false))
                            }

                            Button(action: { print("Change Password tapped") }) {
                                ProfileOptionRowView(icon: "lock.fill", title: "Change Password", subtitle: "Update your password", showChevron: true, showToggle: false, toggleState: .constant(false))
                            }

                            ProfileOptionRowView(icon: "faceid", title: "Face ID / Touch ID", subtitle: "Manage your device security", showChevron: false, showToggle: true, toggleState: $isFaceIDEnabled) {
                                print("Face ID toggle changed to \(isFaceIDEnabled)")
                            }

                            Button(action: { viewModel.logout() }) {
                                ProfileOptionRowView(icon: "arrow.right.square.fill", title: "Log out", subtitle: "Log out from the application", showChevron: true, showToggle: false, toggleState: .constant(false))
                            }
                        }
                        .padding(.vertical)
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
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Title in center
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                // Bottom bar
                ToolbarItemGroup(placement: .bottomBar) {
                    NavigationLink(destination: HomeScreenView()) {
                        VStack {
                            Image(systemName: "house.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            Text("Home")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }

                    NavigationLink(destination: ProfileScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))) {
                        VStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            Text("Profile")
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .toolbarBackground(.white, for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .onChange(of: viewModel.isLoggedIn) { oldValue, newValue in
                if !newValue {
                    print("User logged out. ProfileScreenView should be dismissed.")
                }
            }
        }
    }
}

#Preview {
    ProfileScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
