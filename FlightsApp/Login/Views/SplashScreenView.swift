import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var timerManager = SplashScreenTimerManager.shared
    
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)

            Image("Untitled design-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            VStack {
                Spacer()
                
                Text("FlightsApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .onAppear {
            timerManager.startTimer()
        }
        .onReceive(timerManager.$isTimerFinished) { isFinished in
            if isFinished {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(showSplash: .constant(true)) 
        .environmentObject(LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
