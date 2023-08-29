import Foundation
import SafariServices
import SwiftUI

struct ImageModalView: View {
    var image: UIImage
    var plantName: String // The plant name
    var imageDescription: String // Image description like "Leaf", "Flower", ETC.
    
    @State private var showSafariView = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "chevron.compact.down")
                    .padding(.top, 10)
                
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 10)
                    .padding()
                
                Text(plantName)
                    .font(.headline)
                    .padding(.top, 10)
                
                Text(imageDescription)
                    .font(.subheadline)
                    .padding(.top, 5)
            }
        }
    }
}
