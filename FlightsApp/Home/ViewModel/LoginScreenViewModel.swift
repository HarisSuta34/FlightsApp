import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth

class LoginScreenViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateEmailFormat()
            if errorMessage != nil && emailValidationError == nil && passwordValidationError == nil {
                errorMessage = nil
            }
        }
    }
    @Published var password: String = "" {
        didSet {
            validatePasswordLength()
            if errorMessage != nil && emailValidationError == nil && passwordValidationError == nil {
                errorMessage = nil
            }
        }
    }
    @Published var keepSignedIn: Bool = false
    @Published var showPassword: Bool = false
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    @Published var emailValidationError: String?
    @Published var passwordValidationError: String?
    @Published var isValidEmailFormat: Bool = false
    @Published var isPasswordLongEnough: Bool = false

    @Published var showRegisterScreen: Bool = false
    
    @Published var isLoadingAuth: Bool = false

    private let dataManager: AuthenticationAndDataManagement
    
    init(dataManager: AuthenticationAndDataManagement = LoginDataManager.shared) {
        self.dataManager = dataManager
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""
        
        validateEmailFormat()
        validatePasswordLength()
    }

    func loadLoginStateIfNeeded() {
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""
    }

    func validateEmailFormat() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            emailValidationError = "Email address cannot be empty."
            isValidEmailFormat = false
        } else if !emailPredicate.evaluate(with: email) {
            emailValidationError = "Invalid email format."
            isValidEmailFormat = false
        } else {
            emailValidationError = nil
            isValidEmailFormat = true
        }
    }
    
    func validatePasswordLength() {
        if password.isEmpty {
            passwordValidationError = "Password cannot be empty."
            isPasswordLongEnough = false
        } else if password.count < 6 {
            passwordValidationError = "Password must be at least 6 characters long."
            isPasswordLongEnough = false
        } else {
            passwordValidationError = nil
            isPasswordLongEnough = true
        }
    }

    func login() {
        validateEmailFormat()
        validatePasswordLength()
        
        guard isValidEmailFormat && isPasswordLongEnough else {
            if emailValidationError == nil && passwordValidationError == nil {
                errorMessage = "Please correct the errors in the form."
            }
            return
        }

        errorMessage = nil
        isLoadingAuth = true

        dataManager.loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingAuth = false
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.email = authResult.user.email ?? ""
                    print("Login successful for \(authResult.user.email ?? "unknown user")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = error.localizedDescription
                    print("Login error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func registerUser() {
        validateEmailFormat()
        validatePasswordLength()
        
        guard isValidEmailFormat && isPasswordLongEnough else {
            if emailValidationError == nil && passwordValidationError == nil {
                errorMessage = "Please correct the errors in the form."
            }
            return
        }
        
        errorMessage = nil
        isLoadingAuth = true

        dataManager.registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingAuth = false
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.showRegisterScreen = false
                    self.email = authResult.user.email ?? ""
                    print("Registration successful for \(authResult.user.email ?? "unknown user")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = error.localizedDescription
                    print("Registration error: \(error.localizedDescription)")
                }
            }
        }
    }

    func logout() {
        isLoadingAuth = true
        dataManager.signOut { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingAuth = false
                switch result {
                case .success:
                    self.isLoggedIn = false
                    self.email = ""
                    self.password = ""
                    self.keepSignedIn = false
                    self.errorMessage = nil
                    self.emailValidationError = nil
                    self.passwordValidationError = nil
                    self.isValidEmailFormat = false
                    self.isPasswordLongEnough = false
                    print("User logged out from Firebase.")
                    GIDSignIn.sharedInstance.signOut()
                    print("Google user logged out.")
                case .failure(let error):
                    self.errorMessage = "Logout error: \(error.localizedDescription)"
                    print("Logout error from Firebase: \(error.localizedDescription)")
                }
            }
        }
    }

    func handleGoogleSignInResult(user: GIDGoogleUser?, error: Error?) {
        isLoadingAuth = true
        if let error = error {
            if user == nil && error.localizedDescription.contains("The operation couldn’t be completed. (com.google.GIDSignIn error -4.)") {
                print("Google Sign-In: No previous sign-in. This is expected behavior.")
                self.errorMessage = nil
                self.isLoggedIn = false
                self.isLoadingAuth = false
                return
            }
            
            errorMessage = "Google sign-in failed: \(error.localizedDescription)"
            isLoggedIn = false
            isLoadingAuth = false
            print("Google sign-in error: \(error.localizedDescription)")
            return
        }

        guard let user = user else {
            errorMessage = "Google sign-in failed: No user data."
            isLoggedIn = false
            isLoadingAuth = false
            print("Google sign-in error: No user data.")
            return
        }

        guard let idToken = user.idToken?.tokenString else {
            errorMessage = "Google sign-in failed: Missing ID token."
            isLoggedIn = false
            isLoadingAuth = false
            print("Google sign-in error: Missing ID Token.")
            return
        }
        let accessToken = user.accessToken.tokenString

        dataManager.signInWithGoogle(idToken: idToken, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingAuth = false 
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.email = authResult.user.email ?? ""
                    print("Google sign-in successful and linked with Firebase for: \(authResult.user.email ?? "unknown user")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = "Firebase Google sign-in failed: \(error.localizedDescription)"
                    print("Firebase Google sign-in error: \(error.localizedDescription)")
                }
            }
        }
    }
}
