import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var animationController = AnimationController()
    @StateObject private var apiController = APIController()
    
    var body: some View {
        //move nav stack up to move back button into top right corner use . nav button hidden
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
            .padding(.top, 10)
            
            DistributionZoneView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
