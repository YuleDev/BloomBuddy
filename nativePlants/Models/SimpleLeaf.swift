import Foundation
import SwiftUI

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
