import SwiftUI
import CoreData

struct ContentView: View {
    @State private var leafAngle: Double = 0
    @State private var isAnimating: Bool = false
    @State private var animationTimer: Timer? = nil
    
    // Animation directions and durations
    private let directions: [Double] = [30, 0, -30, 0]
    private let duration: Double = 1.0 // Animation duration in seconds
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack{
                    Text("Bloom Buddy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                                    
                        Text("Bridging Seeds and Sustainability")
                        .font(.headline)
                        .foregroundColor(.green)
                    }
                .padding(.top, 50)
                
                Spacer() // Pushes leaf into middle of screen
                
                // Simple leaf shape
                SimpleLeaf()
                    .stroke(Color.green, lineWidth: 5) // Increase lineWidth for thicker lines
                    .frame(width: 125, height: 200) // Adjust the size as needed
                    .rotationEffect(.degrees(leafAngle), anchor: .bottom)
                
                Spacer() // Push the button to the bottom
                
                // Animation control button
                Button(action: {
                            if self.isAnimating {
                                self.stopMetronomeAnimation()
                            } else {
                                self.startMetronomeAnimation()
                            }
                            self.isAnimating.toggle()
                        }) {
                            Text(isAnimating ? "Stop Animation" : "Start Animation")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }.padding()
            }
        }
    }
    
    func startMetronomeAnimation() {
        var directionIndex = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: self.duration)) {
                self.leafAngle = self.directions[directionIndex]
            }
            directionIndex = (directionIndex + 2) % self.directions.count // Speed of animation
        }
    }
    
    func stopMetronomeAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        withAnimation(.easeInOut(duration: self.duration)) {
            self.leafAngle = 0
        }
    }
}

struct SimpleLeaf: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let widthFactor: CGFloat = 1.2  // Factor to control the width of the leaf

        // Leaf shape
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                          control: CGPoint(x: rect.midX + rect.width * widthFactor / 2, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                          control: CGPoint(x: rect.midX - rect.width * widthFactor / 2, y: rect.midY))

        // Stem
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.2))

        // Central rib
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        // Veins of the leaf
                for i in 1..<5 {
                    let factor = CGFloat(i) / 5.0
                    let t = factor // Using 'factor' as the parameter of the Bezier curve

                    // Calculate coordinates of the point on the edge of the leaf
                    let xRight = pow(1 - t, 2) * rect.midX + 2 * (1 - t) * t * (rect.midX + rect.width * widthFactor / 2) + pow(t, 2) * rect.midX
                    let xLeft = pow(1 - t, 2) * rect.midX + 2 * (1 - t) * t * (rect.midX - rect.width * widthFactor / 2) + pow(t, 2) * rect.midX

                    // Midpoint between the rib and the edge of the leaf, slightly above or below for curve
                    let curveFactor: CGFloat = 0.1
                    let midPointRight = CGPoint(x: (rect.midX + xRight) / 2, y: rect.height * factor + curveFactor * rect.height)
                    let midPointLeft = CGPoint(x: (rect.midX + xLeft) / 2, y: rect.height * factor - curveFactor * rect.height)

                    // Vein on right side
                    path.move(to: CGPoint(x: rect.midX, y: rect.height * factor))
                    path.addQuadCurve(to: CGPoint(x: xRight, y: rect.height * factor),
                                      control: midPointRight)

                    // Vein on left side
                    path.move(to: CGPoint(x: rect.midX, y: rect.height * factor))
                    path.addQuadCurve(to: CGPoint(x: xLeft, y: rect.height * factor),
                                      control: midPointLeft)
                }

                return path
            }
        }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
