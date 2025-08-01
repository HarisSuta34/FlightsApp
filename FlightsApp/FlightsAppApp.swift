import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct FlightsAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var loginViewModel = LoginScreenViewModel(dataManager: LoginDataManager.shared)
    @StateObject private var homeScreenViewModel = HomeScreenViewModel()

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
            .id(loginViewModel.isLoggedIn ? "logged_in_root" : "logged_out_root")
            .onAppear {
                if let clientID = FirebaseApp.app()?.options.clientID {
                    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
                    print("GIDSignIn configured with ClientID: \(clientID)")
                } else {
                    print("ERROR: Firebase clientID not found in configuration. Google sign-in might not work.")
                }

                let keepSignedInPreference = UserDefaults.standard.bool(forKey: "keepSignedIn")

                if !keepSignedInPreference {
                    GIDSignIn.sharedInstance.signOut()
                    print("Google sesija eksplicitno obrisana jer 'Keep me signed in' nije bio odabran.")
                    if loginViewModel.isLoggedIn {
                        loginViewModel.logout()
                    }
                }

                loginViewModel.loadLoginStateIfNeeded()

                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    self.loginViewModel.handleGoogleSignInResult(user: user, error: error)

                    if self.loginViewModel.isLoggedIn && !keepSignedInPreference {
                        print("Sigurnosna provjera: Korisnik je i dalje prijavljen iako 'Keep me signed in' nije bio odabran. Prisilna odjava.")
                        self.loginViewModel.logout()
                    }
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
