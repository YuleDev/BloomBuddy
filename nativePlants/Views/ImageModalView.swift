import Foundation
import SwiftUI

struct ImageModalView: View {
    var image: UIImage
    
    var body: some View {
        // Customize the modal view here
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}
