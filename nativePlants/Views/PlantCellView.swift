import Foundation
import SwiftUI

struct PlantCellView: View {
    @EnvironmentObject var imageCache: ImageCache
    let plant: Plant

    var body: some View {
        HStack {
            if let url = URL(string: plant.imageURL ?? "") {
                if let image = imageCache.get(for: url.absoluteString) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .onAppear {
                            URLSession.shared.dataTask(with: url) { (data, response, error) in
                                if let data = data, let image = UIImage(data: data) {
                                    imageCache.add(image, for: url.absoluteString)
                                }
                            }.resume()
                        }
                }
            }
            
            VStack(alignment: .leading) {
                Text(plant.commonName ?? "No common name")
                    .font(.headline)
                    .underline()
                Text(plant.scientificName)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
    }
}
