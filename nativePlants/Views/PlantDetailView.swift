import Foundation
import Combine
import SwiftUI
import SafariServices

// add favorite tab?

struct PlantDetailView: View {
    let selectedZone = UserDefaults.standard.string(forKey: "selectedZone")
    
    @ObservedObject var apiController: APIController
    @EnvironmentObject var imageCache: ImageCache
    @State var isImageLoading: Bool = true
    let plant: Plant
    
    @State private var showLeavesImages: Bool = false
    @State private var showFlowerImages: Bool = false
    @State private var showBarkImages: Bool = false
    @State private var showFruitImages: Bool = false
    
    @State private var showAmazonSearch = false
    @State private var showSafariView = false

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    ZStack {
                        // Default Gray Image
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)

                        if let urlString = apiController.plantDetail?.image_url, let url = URL(string: urlString) {
                            if let image = imageCache.get(for: url.absoluteString) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 300)
                                    .clipped()
                                    .cornerRadius(10)
                            } else {
                                // Progress Wheel
                                ProgressView()
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
                    }
                    Spacer()
                }
                
                if apiController.plantDetail == nil {
                    HStack{
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                            .scaleEffect(2)
                        Spacer()
                    }

                } else {
                    
                    Group{
                        // Title for plant, IE Common name of plant.
                        HStack{
                            Spacer()
                            Text(apiController.plantDetail?.common_name ?? "No common name")
                                .font(.title)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text(" Scientific name: \(apiController.plantDetail?.scientific_name ?? "No scientific name")")
                                .font(.headline)
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
                }
        
                Group{
                    // checks for if the plant is a vegetable
                    if let veggeBool = apiController.plantDetail?.vegetable {
                        HStack{
                            Spacer()
                            Text(veggeBool ? "This plant is considered a vegetable!" : "This plant is not considered a vegetable.")
                            Spacer()
                        }
                    }
                    
                    // checks for if the plant is edible
                    if let ediblePlant = apiController.plantDetail?.main_species.edible, let commonName = apiController.plantDetail?.common_name {
                        HStack{
                            Spacer()
                            Text(ediblePlant ? "\(commonName) Is Edible!" : "\(commonName) is not edible!")
                            Spacer()
                        }
                    }
                }
                
                Group {
                    
                    // checks for leaf images, then displays found images in a carousel
                    HStack{
                        Spacer()
                        DisclosureGroup("Images for identification of leaves.", isExpanded: $showLeavesImages) {
                            if let leafs = apiController.plantDetail?.main_species.images.leaf {
                                ImageCarouselView(imageUrls: leafs.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Leaf")
                                    .frame(height: 150)
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .accentColor(.green)
                        Spacer()
                    }
                    
                    // checks for flower images, then displays found images in a carousel
                    HStack{
                        Spacer()
                        DisclosureGroup("Images for identification of flowers.", isExpanded: $showFlowerImages) {
                                      if let flowers = apiController.plantDetail?.main_species.images.flower {
                                          ImageCarouselView(imageUrls: flowers.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Flower")
                                              .frame(height: 150)
                                      }
                                  }
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .accentColor(.green)
                        Spacer()
                    }
                    
                    // checks for bark images, then displays found images in a carousel
                    HStack{
                        Spacer()
                        DisclosureGroup("Images for identification of bark.", isExpanded: $showBarkImages) {
                                      if let bark = apiController.plantDetail?.main_species.images.bark {
                                          ImageCarouselView(imageUrls: bark.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Bark")
                                              .frame(height: 150)
                                      }
                                  }
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .accentColor(.green)
                        Spacer()
                    }
                    
                    // checks for fruit images, then displays tfound images in a carousel
                    HStack{
                        Spacer()
                        DisclosureGroup("Images for identification of bloom/fruit.", isExpanded: $showFruitImages) {
                                      if let fruit = apiController.plantDetail?.main_species.images.fruit {
                                          ImageCarouselView(imageUrls: fruit.compactMap { URL(string: $0.image_url) }, plantName: apiController.plantDetail?.common_name ?? "Unknown Plant", imageDescription: "Fruit")
                                              .frame(height: 150)
                                      }
                                  }
                        .font(.headline)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .accentColor(.green)
                        Spacer()
                    }
                }
                
                // Button for amazon link to seeds for plant.
                Group{
                    HStack{
                        Spacer()
                        // for the wikipedia article for the plant
                        Button(action: {
                            showSafariView = true
                        }) {
                            Image("wikipedia")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.deepGreen, Color.lightGreen]), startPoint: .leading, endPoint: .trailing) // Gradient background
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 10)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 10) // Shadow for depth
                                .scaleEffect(1.05) // Slight scaling to make it larger
                        }
                    
                    .sheet(isPresented: $showSafariView) {
                        SafariView(url: URL(string: "https://en.wikipedia.org/wiki/\(String(describing: plant.commonName!.replacingOccurrences(of: " ", with: "_")))")!)
                    }
                    Spacer()
                    
                        // the amazon button
                        Button(action: {
                            self.showAmazonSearch = true
                        }) {
                                Image("cart")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.lightGreen, Color.deepGreen]), startPoint: .leading, endPoint: .trailing) // Gradient background
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.top, 10)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10) // Shadow for depth
                                    .scaleEffect(1.05) // Slight scaling to make it larger
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
