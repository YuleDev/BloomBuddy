import Foundation
import SwiftUI

struct LoadingView: View {
    @ObservedObject var animationController = AnimationController()
    
    var body: some View {
        VStack {
            SimpleLeaf()
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 125, height: 200)
                .rotationEffect(.degrees(animationController.leafAngle), anchor: .bottom)
            Text("Loading...")
        }
        .onAppear {
            animationController.startMetronomeAnimation()
        }
        .onDisappear {
            animationController.stopMetronomeAnimation()
        }
    }
}
