import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct LoginSheetView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text("Welcome back to the app")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 30)
            
            VStack(spacing: 20) {
                TextField("Email Address", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                HStack {
                    ZStack {
                        // SecureField se uvijek prikazuje, ali se skriva/prikazuje pomoću opacity
                        SecureField("Password", text: $viewModel.password)
                            .opacity(viewModel.showPassword ? 0 : 1)
                            .disabled(viewModel.showPassword) // Onemogućava interakciju kada je skriven
                        
                        // TextField se uvijek prikazuje, ali se skriva/prikazuje pomoću opacity
                        TextField("Password", text: $viewModel.password)
                            .opacity(viewModel.showPassword ? 1 : 0)
                            .disabled(!viewModel.showPassword) // Onemogućava interakciju kada je skriven
                    }
                    .animation(.none, value: viewModel.showPassword) // Uklanjamo animaciju da ne glitcha

                    Button {
                        viewModel.showPassword.toggle()
                    } label: {
                        Image(systemName: viewModel.showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        print("Forgot Password tapped")
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                
                Toggle(isOn: $viewModel.keepSignedIn) {
                    Text("Keep me signed in")
                }
                .toggleStyle(CheckboxToggleStyle())
                .foregroundColor(.black)
                
                Button {
                    viewModel.login()
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Text("or sign in with")
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                
                GoogleSignInButton() {
                    DispatchQueue.main.async {
                        if let presentingVC = getRootViewController() {
                            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
                                viewModel.handleGoogleSignInResult(user: result?.user, error: error)
                            }
                        } else {
                            print("ERROR: Could not get root view controller for Google Sign-In presentation.")
                            viewModel.errorMessage = "Greška pri prikazu Google prijave."
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
                Button {
                    viewModel.showRegisterScreen = true
                } label: {
                    Text("Create an account")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
        }
    }
 
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var root = window.rootViewController
        while let presentedVC = root?.presentedViewController {
            root = presentedVC
        }
        return root
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
