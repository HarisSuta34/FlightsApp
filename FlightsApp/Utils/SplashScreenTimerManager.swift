

import Foundation
import Combine

class SplashScreenTimerManager: ObservableObject {

    static let shared = SplashScreenTimerManager()
    
    private init() {}

    private var timer: Timer?
    @Published var elapsedSeconds = 0
    @Published var isTimerFinished = false

    func startTimer() {
        guard timer == nil else { return }

        elapsedSeconds = 0
        isTimerFinished = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedSeconds += 1
            
            
            if self.elapsedSeconds >= 3 {
                self.timer?.invalidate()
                self.timer = nil
                self.isTimerFinished = true
            }
        }
    }
    
}
