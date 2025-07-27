import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct FlightsAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var loginViewModel = LoginScreenViewModel(dataManager: LoginDataManager.shared)

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView(showSplash: $showSplash)
                } else if loginViewModel.isLoggedIn {
                    MainTabView(viewModel: loginViewModel)
                } else {
                    LoginScreenView(viewModel: loginViewModel)
                }
                
                if loginViewModel.isLoadingAuth {
                    LoadingView()
                }
            }
            .onAppear {
                if let clientID = FirebaseApp.app()?.options.clientID {
                    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
                    print("GIDSignIn configured with ClientID: \(clientID)")
                } else {
                    print("ERROR: Firebase clientID not found in configuration. Google sign-in might not work.")
                }

                loginViewModel.loadLoginStateIfNeeded()
                
                // NOVO: Proveri "Keep me signed in" preferencu pri pokretanju
                let keepSignedInPreference = UserDefaults.standard.bool(forKey: "keepSignedIn")
                if loginViewModel.isLoggedIn && !keepSignedInPreference {
                    print("User is logged in but 'Keep me signed in' was false. Logging out automatically.")
                    loginViewModel.logout() // Automatski odjavi korisnika
                }

                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    self.loginViewModel.handleGoogleSignInResult(user: user, error: error)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase is successfully configured.")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
