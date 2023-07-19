import Foundation
import Combine
import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var apiController: APIController
    let plant: Plant
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(apiController.plantDetail?.common_name ?? "No common name")
                    .font(.title)
                Text(apiController.plantDetail?.scientific_name ?? "No scientific name")
                    .font(.headline)
                Text("Identity Number: \(plant.id)")
                    .font(.subheadline)
                Text("Observations: \(apiController.plantDetail?.observations ?? "No observations")")
                    .font(.subheadline)
                Text("nativity: \(nativityDetermination())")
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            apiController.fetchPlantDetail(plantID: plant.id)
        }
    }
    
    func nativityDetermination() -> String {
        guard let nativeRegions = apiController.plantDetail?.main_species.distribution.native else {
            return "This plant's nativity is unknown"
        }

        for region in nativeRegions {
            if region.lowercased() == "utah" {
                return "This plant is native"
            }
        }
        
        return "This plant is not native"
    }
}
