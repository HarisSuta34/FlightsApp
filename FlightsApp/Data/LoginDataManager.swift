import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationAndDataManagement {
    func registerUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(idToken: String, accessToken: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func saveUserData(uid: String, email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getUserData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    
    var isAuthenticated: Bool { get }
    var currentUserID: String? { get }
}

class LoginDataManager: AuthenticationAndDataManagement {
    static let shared = LoginDataManager()

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private init() {}

    var isAuthenticated: Bool {
        return auth.currentUser != nil
    }

    var currentUserID: String? {
        return auth.currentUser?.uid
    }

    func registerUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let authResult = authResult else {
                completion(.failure(AuthError.unknownError))
                return
            }
            self.saveUserData(uid: authResult.user.uid, email: email) { result in
                switch result {
                case .success:
                    completion(.success(authResult))
                case .failure(let dbError):
                    completion(.failure(dbError))
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let authResult = authResult else {
                completion(.failure(AuthError.unknownError))
                return
            }
            completion(.success(authResult))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

    func signInWithGoogle(idToken: String, accessToken: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        auth.signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let authResult = authResult else {
                completion(.failure(AuthError.unknownError))
                return
            }
            self.saveUserData(uid: authResult.user.uid, email: authResult.user.email ?? "") { result in
                switch result {
                case .success:
                    completion(.success(authResult))
                case .failure(let dbError):
                    completion(.failure(dbError))
                }
            }
        }
    }

    func saveUserData(uid: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        userRef.setData(["email": email, "lastLogin": FieldValue.serverTimestamp()], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getUserData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists, let data = document.data() else {
                completion(.failure(AuthError.userDataNotFound))
                return
            }
            completion(.success(data))
        }
    }
}

enum AuthError: Error, LocalizedError {
    case unknownError
    case userDataNotFound
    
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Došlo je do nepoznate greške. Pokušajte ponovo."
        case .userDataNotFound:
            return "Korisnički podaci nisu pronađeni u bazi."
        }
    }
}
