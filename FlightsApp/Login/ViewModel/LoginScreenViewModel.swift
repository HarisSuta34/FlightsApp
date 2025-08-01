import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

class LoginScreenViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            // Interna validacija se poziva da se ažurira ispravnost za dugme, ali ne prikazuje greške
            validateEmailFormatInternal()
            // Briše opštu poruku o grešci kada se email promijeni, ako nije specifična greška polja
            if errorMessage != nil && emailValidationError == nil && passwordValidationError == nil {
                errorMessage = nil
            }
        }
    }
    @Published var password: String = "" {
        didSet {
            // Interna validacija se poziva da se ažurira ispravnost za dugme, ali ne prikazuje greške
            validatePasswordLengthInternal()
            // Briše opštu poruku o grešci kada se lozinka promijeni, ako nije specifična greška polja
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

    @Published var emailFieldTouched: Bool = false
    @Published var passwordFieldTouched: Bool = false

    @Published var showRegisterScreen: Bool = false
    
    @Published var isLoadingAuth: Bool = false

    @Published var username: String?
    @Published var showEditProfileSheet: Bool = false
    @Published var newUsernameInput: String = ""
    @Published var usernameUpdateErrorMessage: String?
    @Published var isUpdatingUsername: Bool = false

    @Published var loginProvider: String = "Email/Password"
    @Published var creationDate: Date?
    
    @Published var navigateToChangePassword = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    @Published var showForgotPasswordSheet: Bool = false
    @Published var forgotPasswordEmail: String = ""
    @Published var forgotPasswordMessage: String?
    @Published var isSendingPasswordReset: Bool = false
    
    internal let dataManager: AuthenticationAndDataManagement
    
    init(dataManager: AuthenticationAndDataManagement = LoginDataManager.shared) {
        self.dataManager = dataManager
        self.keepSignedIn = UserDefaults.standard.bool(forKey: "keepSignedIn")
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""
        
        if isLoggedIn, let uid = dataManager.currentUserID {
            fetchUsername(for: uid)
            if let currentUser = Auth.auth().currentUser {
                self.loginProvider = currentUser.providerData.first?.providerID == "google.com" ? "Google" : "Email/Password"
                self.creationDate = currentUser.metadata.creationDate
            }
        }

        validateEmailFormatInternal()
        validatePasswordLengthInternal()
    }

    func loadLoginStateIfNeeded() {
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""
        
        if isLoggedIn, let uid = dataManager.currentUserID {
            fetchUsername(for: uid)
            if let currentUser = Auth.auth().currentUser {
                self.loginProvider = currentUser.providerData.first?.providerID == "google.com" ? "Google" : "Email/Password"
                self.creationDate = currentUser.metadata.creationDate
            }
        } else {
            self.username = nil
            self.loginProvider = "Email/Password"
            self.creationDate = nil
        }
    }

    private func validateEmailFormatInternal() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            isValidEmailFormat = false
        } else if !emailPredicate.evaluate(with: email) {
            isValidEmailFormat = false
        } else {
            isValidEmailFormat = true
        }
    }

    func validateEmailFormat() {
        validateEmailFormatInternal()
        
        guard emailFieldTouched else {
            emailValidationError = nil
            return
        }

        if email.isEmpty {
            emailValidationError = "Email address cannot be empty."
        } else if !isValidEmailFormat {
            emailValidationError = "Invalid email format."
        } else {
            emailValidationError = nil
        }
    }
    
    private func validatePasswordLengthInternal() {
        if password.isEmpty {
            isPasswordLongEnough = false
        } else if password.count < 6 {
            isPasswordLongEnough = false
        } else {
            isPasswordLongEnough = true
        }
    }

    func validatePasswordLength() {
        validatePasswordLengthInternal()
        
        guard passwordFieldTouched else {
            passwordValidationError = nil
            return
        }

        if password.isEmpty {
            passwordValidationError = "Password cannot be empty."
        } else if !isPasswordLongEnough {
            passwordValidationError = "Password must be at least 6 characters long."
        } else {
            passwordValidationError = nil
        }
    }

    var isRegisterButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty && isValidEmailFormat && isPasswordLongEnough
    }
    
    var isLoginButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty && isValidEmailFormat && isPasswordLongEnough
    }

    func login() {
        emailFieldTouched = true
        passwordFieldTouched = true
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
                    UserDefaults.standard.set(self.keepSignedIn, forKey: "keepSignedIn")
                    print("Login successful for \(authResult.user.email ?? "unknown user"). KeepSignedIn: \(self.keepSignedIn)")
                    self.fetchUsername(for: authResult.user.uid)
                    self.loginProvider = "Email/Password"
                    self.creationDate = authResult.user.metadata.creationDate
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = error.localizedDescription
                    print("Login error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func registerUser() {
        emailFieldTouched = true
        passwordFieldTouched = true
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
                    UserDefaults.standard.set(self.keepSignedIn, forKey: "keepSignedIn")
                    print("Registration successful for \(authResult.user.email ?? "unknown user"). KeepSignedIn: \(self.keepSignedIn)")
                    self.emailFieldTouched = false
                    self.passwordFieldTouched = false
                    self.emailValidationError = nil
                    self.passwordValidationError = nil
                    self.fetchUsername(for: authResult.user.uid)
                    self.loginProvider = "Email/Password"
                    self.creationDate = authResult.user.metadata.creationDate
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
                    UserDefaults.standard.set(false, forKey: "keepSignedIn")
                    self.errorMessage = nil
                    self.emailValidationError = nil
                    self.passwordValidationError = nil
                    self.isValidEmailFormat = false
                    self.isPasswordLongEnough = false
                    self.emailFieldTouched = false
                    self.passwordFieldTouched = false
                    self.username = nil
                    self.loginProvider = "Email/Password"
                    self.creationDate = nil
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
                    UserDefaults.standard.set(self.keepSignedIn, forKey: "keepSignedIn")
                    print("Google sign-in successful and linked with Firebase for: \(authResult.user.email ?? "unknown user"). KeepSignedIn: \(self.keepSignedIn)")
                    self.fetchUsername(for: authResult.user.uid)
                    self.loginProvider = "Google"
                    self.creationDate = authResult.user.metadata.creationDate
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = "Firebase Google sign-in failed: \(error.localizedDescription)"
                    print("Firebase Google sign-in error: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchUsername(for uid: String) {
        dataManager.getUserData(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let userData):
                    self.username = userData["username"] as? String
                    self.newUsernameInput = self.username ?? ""
                    print("Fetched username: \(self.username ?? "N/A") for UID: \(uid)")
                case .failure(let error):
                    print("Error fetching user data for username: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateUsername(newUsername: String) {
        let trimmedUsername = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUsername.isEmpty else {
            usernameUpdateErrorMessage = "Username cannot be empty."
            return
        }

        guard isLoggedIn, let uid = dataManager.currentUserID else {
            usernameUpdateErrorMessage = "User is not logged in."
            return
        }

        usernameUpdateErrorMessage = nil
        isUpdatingUsername = true
        
        dataManager.updateUserData(uid: uid, data: ["username": trimmedUsername]) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isUpdatingUsername = false
                switch result {
                case .success:
                    self.username = trimmedUsername
                    self.showEditProfileSheet = false
                    print("Username updated successfully to: \(trimmedUsername)")
                case .failure(let error):
                    self.usernameUpdateErrorMessage = "Error updating username: \(error.localizedDescription)"
                    print("Failed to update username: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func handleChangePassword(onNotAllowed: @escaping () -> Void) {
        if let user = Auth.auth().currentUser {
            if user.providerData.contains(where: { $0.providerID == "password" }) {
                self.navigateToChangePassword = true
            } else {
                onNotAllowed()
            }
        }
    }
    
    func changePassword(to newPassword: String, confirmPassword: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
            onError("Please fill in all fields.")
            return
        }

        guard newPassword == confirmPassword else {
            onError("Passwords do not match.")
            return
        }

        guard let user = Auth.auth().currentUser else {
            onError("No user is currently logged in.")
            return
        }
        
        guard newPassword.count >= 6 else {
            onError("New password must be at least 6 characters long.")
            return
        }

        isLoadingAuth = true

        user.updatePassword(to: newPassword) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingAuth = false
                if let error = error {
                    onError("Failed to update password: \(error.localizedDescription)")
                    print("Error updating password: \(error.localizedDescription)")
                } else {
                    onSuccess()
                    print("Password updated successfully. User will be logged out.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.logout()
                        print("User automatically logged out after password change.")
                    }
                }
            }
        }
    }

    func sendPasswordResetEmail() {
        guard !forgotPasswordEmail.isEmpty else {
            forgotPasswordMessage = "Please enter your email address."
            return
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: forgotPasswordEmail) else {
            forgotPasswordMessage = "Invalid email format."
            return
        }

        forgotPasswordMessage = nil
        isSendingPasswordReset = true

        Auth.auth().sendPasswordReset(withEmail: forgotPasswordEmail) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSendingPasswordReset = false
                if let error = error {
                    if let authErrorCode = AuthErrorCode(rawValue: error._code) {
                        switch authErrorCode {
                        case .userNotFound:
                            self.forgotPasswordMessage = "No user found with that email address."
                        case .tooManyRequests:
                            self.forgotPasswordMessage = "Too many requests. Please try again later."
                        default:
                            self.forgotPasswordMessage = "Error: \(error.localizedDescription)"
                        }
                    } else {
                        self.forgotPasswordMessage = "Error: \(error.localizedDescription)"
                    }
                    print("Error sending password reset email: \(error.localizedDescription)")
                } else {
                    self.forgotPasswordMessage = "Password reset email sent to \(self.forgotPasswordEmail). Please check your inbox."
                    print("Password reset email sent successfully to \(self.forgotPasswordEmail)")
                }
            }
        }
    }
}
