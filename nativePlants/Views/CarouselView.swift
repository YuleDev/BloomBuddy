import Foundation
import SwiftUI

struct SelectedImage: Identifiable {
    var id = UUID()
    var image: UIImage
}

struct ImageCarouselView: View {
    @EnvironmentObject var imageCache: ImageCache
    var imageUrls: [URL]
    
    var plantName: String
    var imageDescription: String

    @State private var showModal = false
    @State private var selectedImage: SelectedImage? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(imageUrls, id: \.absoluteString) { url in
                    GeometryReader { geometry in
                        if let image = imageCache.get(for: url.absoluteString) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                                .frame(width: 150, height: 150) // Set the desired size
                                .onTapGesture {
                                    selectedImage = SelectedImage(image: image)
                                    showModal = true // new
                                }
                        } else {
                            Color.clear
                                .frame(width: 150, height: 150)
                                .onAppear {
                                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                                        if let data = data, let image = UIImage(data: data) {
                                            DispatchQueue.main.async {
                                                imageCache.add(image, for: url.absoluteString)
                                            }
                                        }
                                    }
                                    .resume()
                            }
                        }
                    }
                    .frame(width: 150, height: 150) // Ensure consistent size
                }
            }
        }
//        .sheet(item: $selectedImage) { image in
//            ImageModalView(image: image.image)
//        }
        .sheet(item: $selectedImage) { image in
            ImageModalView(image: image.image, plantName: plantName, imageDescription: imageDescription)
        }
    }
}

