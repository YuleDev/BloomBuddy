import Foundation
import SwiftUI

struct AnimationView: View {
    @ObservedObject var animationController: AnimationController
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                SimpleLeaf()
                    .stroke(Color.green, lineWidth: 5)
                    .frame(width: 125, height: 200)
                    .rotationEffect(.degrees(animationController.leafAngle), anchor: .bottom)
                
                Spacer()
                
                Button(action: {
                    animationController.toggleAnimation()
                }) {
                    Text(animationController.isAnimating ? "Stop Animation" : "Start Animation")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.padding()
            }
        }
    }
}

