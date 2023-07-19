import Foundation
import SwiftUI

class AnimationController: ObservableObject {
    @Published var leafAngle: Double = 0
    @Published var isAnimating: Bool = false
    var animationTimer: Timer? = nil
    var duration: Double = 1.0
    var directions: [Double] = [30, 0, -30, 0]

    func startMetronomeAnimation() {
        var directionIndex = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: self.duration)) {
                self.leafAngle = self.directions[directionIndex]
            }
            directionIndex = (directionIndex + 2) % self.directions.count
        }
    }
    
    func stopMetronomeAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        withAnimation(.easeInOut(duration: self.duration)) {
            self.leafAngle = 0
        }
    }
    
    func toggleAnimation() {
        if isAnimating {
            stopMetronomeAnimation()
        } else {
            startMetronomeAnimation()
        }
        isAnimating.toggle()
    }
}
