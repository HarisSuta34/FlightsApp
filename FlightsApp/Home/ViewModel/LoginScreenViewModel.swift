import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth

class LoginScreenViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var keepSignedIn: Bool = false
    @Published var showPassword: Bool = false
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    @Published var showRegisterScreen: Bool = false

    private let dataManager: AuthenticationAndDataManagement
    
    init(dataManager: AuthenticationAndDataManagement = LoginDataManager.shared) {
        self.dataManager = dataManager
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""
    }

    func loadLoginStateIfNeeded() {
        self.isLoggedIn = dataManager.isAuthenticated
        self.email = dataManager.isAuthenticated ? (Auth.auth().currentUser?.email ?? "") : ""

        if isLoggedIn {
            print("Korisnik je prijavljen putem Firebase-a.")
            if let uid = dataManager.currentUserID {
                dataManager.getUserData(uid: uid) { result in
                    switch result {
                    case .success(let userData):
                        print("Dohvaćeni korisnički podaci iz Firestore-a: \(userData)")
                    case .failure(let error):
                        print("Greška pri dohvaćanju korisničkih podataka: \(error.localizedDescription)")
                        self.errorMessage = "Greška pri dohvaćanju podataka."
                    }
                }
            }
        } else {
            print("Korisnik nije prijavljen.")
        }
    }

    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Molimo unesite email i lozinku."
            return
        }

        errorMessage = nil

        dataManager.loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.email = authResult.user.email ?? ""
                    print("Prijava uspješna za \(authResult.user.email ?? "nepoznatog korisnika")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = error.localizedDescription
                    print("Greška pri prijavi: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func registerUser() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Molimo unesite email i lozinku za registraciju."
            return
        }
        
        errorMessage = nil

        dataManager.registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.showRegisterScreen = false
                    self.email = authResult.user.email ?? ""
                    print("Registracija uspješna za \(authResult.user.email ?? "nepoznatog korisnika")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = error.localizedDescription
                    print("Greška pri registraciji: \(error.localizedDescription)")
                }
            }
        }
    }

    func logout() {
        dataManager.signOut { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.isLoggedIn = false
                    self.email = ""
                    self.password = ""
                    self.keepSignedIn = false
                    self.errorMessage = nil
                    print("Korisnik je odjavljen iz Firebase-a.")
                    GIDSignIn.sharedInstance.signOut()
                    print("Google korisnik odjavljen.")
                case .failure(let error):
                    self.errorMessage = "Greška pri odjavi: \(error.localizedDescription)"
                    print("Greška pri odjavi iz Firebase-a: \(error.localizedDescription)")
                }
            }
        }
    }

    func handleGoogleSignInResult(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            if user == nil && error.localizedDescription.contains("The operation couldn’t be completed. (com.google.GIDSignIn error -4.)") {
                print("Google Sign-In: Nema prethodne prijave. Ovo je očekivano ponašanje.")
                self.errorMessage = nil
                self.isLoggedIn = false
                return
            }
            
            errorMessage = "Google prijava neuspješna: \(error.localizedDescription)"
            isLoggedIn = false
            print("Google sign-in error: \(error.localizedDescription)")
            return
        }

        guard let user = user else {
            errorMessage = "Google prijava neuspješna: Nema korisničkih podataka."
            isLoggedIn = false
            print("Google sign-in error: No user data.")
            return
        }

        guard let idToken = user.idToken?.tokenString else {
            errorMessage = "Google prijava neuspješna: Nema ID tokena."
            isLoggedIn = false
            print("Google sign-in error: Missing ID Token.")
            return
        }
        let accessToken = user.accessToken.tokenString

        dataManager.signInWithGoogle(idToken: idToken, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let authResult):
                    self.isLoggedIn = true
                    self.errorMessage = nil
                    self.email = authResult.user.email ?? ""
                    print("Google prijava uspješna i povezana sa Firebase-om za: \(authResult.user.email ?? "nepoznatog korisnika")")
                case .failure(let error):
                    self.isLoggedIn = false
                    self.errorMessage = "Firebase Google prijava neuspješna: \(error.localizedDescription)"
                    print("Firebase Google sign-in error: \(error.localizedDescription)")
                }
            }
        }
    }
}
