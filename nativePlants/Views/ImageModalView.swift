import Foundation
import SafariServices
import SwiftUI

// CORRECT THE CHEVRON AND BUTTON PLACEMENT, LIKELY BEING ALTERED BY THE IMAGE BUT FORCE THEM TO THE TOP OF THE MODAL!

struct ImageModalView: View {
    var image: UIImage
    var plantName: String // The plant name
    var imageDescription: String // Image description like "Leaf", "Flower", ETC.
    
    @State private var showSafariView = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.green)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.compact.down")
                        .padding(.top, 10)
                    
                    Spacer()
                }
                
                VStack{
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
     //   .padding(.top, -10)
    }
}
