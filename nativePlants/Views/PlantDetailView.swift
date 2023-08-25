import Foundation
import Combine
import SwiftUI

struct PlantDetailView: View {
    let selectedZone = UserDefaults.standard.string(forKey: "selectedZone")
    
    @ObservedObject var apiController: APIController
    @EnvironmentObject var imageCache: ImageCache
    @State var isImageLoading: Bool = true
    let plant: Plant
    
// changed code so below isnt neccessary
//    @State private var leafImages: [URL] = []
//    @State private var barkImages: [URL] = []
//    @State private var flowerImages: [URL] = []
//    @State private var fruitImages: [URL] = []
//    @State private var habitImages: [URL] = []
    
    @State private var showAmazonSearch = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    if let urlString = apiController.plantDetail?.image_url, let url = URL(string: urlString) {
                        if let image = imageCache.get(for: url.absoluteString) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipped()
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
                    Spacer()
                }
                
                // Title for plant, IE Common name of plant.
                HStack{
                    Spacer()
                    Text(apiController.plantDetail?.common_name ?? "No common name")
                        .font(.title)
                    Spacer()
                }
                
                Group{
                    HStack{
                        Spacer()
                        Text(" Scientific name: \(apiController.plantDetail?.scientific_name ?? "No scientific name")")
                            .font(.headline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text(verbatim: "Identity Number: \(plant.id)")
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("This plant has been observed commonly in: \(apiController.plantDetail?.observations ?? "No observations")")
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("nativity: \(nativityDetermination())")
                            .foregroundColor(self.nativityDetermination() == "This plant is native" ? .green : .red)
                            .fontWeight(self.nativityDetermination() == "This plant is native" ? .light : .heavy)
                        Spacer()
                    }
                }
                
                Group{
                    // checks for if the plant is a vegetable
                    if let veggeBool = apiController.plantDetail?.vegetable {
                        HStack{
                            Spacer()
                            Text(veggeBool ? "This plant is considered a vegetable" : "This plant is not considered a vegetable.")
                            Spacer()
                        }
                    }
                    
                    // checks for if the plant is edible
                    if let ediblePlant = apiController.plantDetail?.main_species.edible, let commonName = apiController.plantDetail?.common_name {
                        HStack{
                            Spacer()
                            Text(ediblePlant ? "\(commonName) Is Edible" : "\(commonName) is not edible")
                            Spacer()
                        }
                    }
                }
                
                Group {
                    // checks for leaf images, then displays found images in a carousel
                    if let leafs = apiController.plantDetail?.main_species.images.leaf {
                        HStack{
                            Spacer()
                            Text("Images for identification of leaves")
                                .underline()
                            Spacer()
                        }
                        
                        ImageCarouselView(imageUrls: leafs.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Leaf")
                            .frame(height: 150)
                    }
                    
                    // checks for flower images, then displays tfound images in a carousel
                    if let flowers = apiController.plantDetail?.main_species.images.flower {
                        HStack{
                            Spacer()
                            Text("Images for identification of flowers")
                                .underline()
                            Spacer()
                        }
                        
                        ImageCarouselView(imageUrls: flowers.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Flower")
                            .frame(height: 150)
                    }
                    
                    // checks for bark images, then displays tfound images in a carousel
                    if let barks = apiController.plantDetail?.main_species.images.bark {
                        HStack{
                            Spacer()
                            Text("Images for identification of the bark")
                                .underline()
                            Spacer()
                        }
                        
                        ImageCarouselView(imageUrls: barks.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Bark")
                            .frame(height: 150)
                    }
                    
                    // checks for fruit images, then displays tfound images in a carousel
                    if let fruits = apiController.plantDetail?.main_species.images.fruit {
                        HStack{
                            Spacer()
                            Text("Images for identification of fruits / blooms.")
                                .underline()
                            Spacer()
                        }
                        
                        ImageCarouselView(imageUrls: fruits.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Fruits")
                            .frame(height: 150)
                    }
                }
                
                // Button for amazon link to seeds for plant.
                Group{
                    HStack {
                        Spacer()
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
                        Spacer()
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
    }
        
    // Func for finding nativity of plant by comparing the selected zone against the array of places the plant is native to.
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
