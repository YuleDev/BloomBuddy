import Foundation
import Combine
import SwiftUI

struct PlantDetailView: View {
    let selectedZone = UserDefaults.standard.string(forKey: "selectedZone")
    
    @ObservedObject var apiController: APIController
    @EnvironmentObject var imageCache: ImageCache
    @State var isImageLoading: Bool = true
    let plant: Plant
    
    @State private var leafImages: [URL] = []
    @State private var barkImages: [URL] = []
    @State private var flowerImages: [URL] = []
    @State private var fruitImages: [URL] = []
    @State private var habitImages: [URL] = []
    
    @State private var showAmazonSearch = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let urlString = apiController.plantDetail?.image_url, let url = URL(string: urlString) {
                    if let image = imageCache.get(for: url.absoluteString) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } else {
                        ProgressView()
                            .onAppear {
                                URLSession.shared.dataTask(with: url) { (data, response, error) in
                                    if let data = data, let image = UIImage(data: data) {
                                        DispatchQueue.main.async { // ensure you are performing UI updates on main thread.
                                            imageCache.add(image, for: url.absoluteString)
                                        }
                                    }
                                }
                                .resume()
                            }
                    }
                }
                
                Text(apiController.plantDetail?.common_name ?? "No common name")
                    .font(.title)
                Text(apiController.plantDetail?.scientific_name ?? "No scientific name")
                    .font(.headline)
                Text("Identity Number: \(plant.id)")
                    .font(.subheadline)
                Text("Observations: \(apiController.plantDetail?.observations ?? "No observations")")
                    .font(.subheadline)
                Text("nativity: \(nativityDetermination())")
                    .foregroundColor(self.nativityDetermination() == "This plant is native" ? .green : .red)
                    .fontWeight(self.nativityDetermination() == "This plant is native" ? .light : .heavy)
                
                // the following text has a large gap between the text and the carousel that is undesired
                Text("Here are some images of the leaves for better identification.")
                    .underline()
                
                if let leafs = apiController.plantDetail?.main_species.images.leaf {
                ImageCarouselView(imageUrls: leafs.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Leaf")
                    .frame(height: 300)
                }
                
                // the following button needs to be centered
                Button(action: {
                    self.showAmazonSearch = true
                }) {
                    Text("Buy \(apiController.plantDetail?.common_name ?? "this plant") seeds on Amazon")
                        .font(.headline) // Bigger font
                        .fontWeight(.bold) // Bold font
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.lightGreen, Color.deepGreen]), startPoint: .leading, endPoint: .trailing) // Gradient background
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10) // Shadow for depth
                        .scaleEffect(1.05) // Slight scaling to make it larger
                        .padding(.top, 10)
                }
                .sheet(isPresented: $showAmazonSearch) {
                    let searchTerm = "\(apiController.plantDetail?.common_name ?? "") seeds"
                    let formattedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                    let amazonURL = URL(string: "https://www.amazon.com/s?field-keywords=\(formattedSearchTerm)")!
                    SafariView(url: amazonURL)
                }
                
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            apiController.clearPlantDetails()
            apiController.fetchPlantDetail(plantID: plant.id)
        }
    }
        
        func nativityDetermination() -> String {
            guard let nativeRegions = apiController.plantDetail?.main_species.distribution.native else {
                return "This plant's nativity is unknown"
            }
            
            for region in nativeRegions {
                if region.lowercased() == selectedZone?.lowercased() {
                    return "This plant is native"
                }
            }
            
            return "This plant is not native"
        }
    }
