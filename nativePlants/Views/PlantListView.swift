import Foundation
import SwiftUI

struct PlantListView: View {
    @ObservedObject var apiController: APIController
    var selectedZone: String
    
    // Computed property that provides unique plants
    var uniquePlants: [Plant] {
        let plants = apiController.plants
        let uniquePlants = Array(Set(plants)).sorted(by: { $0.id < $1.id })
        return uniquePlants
    }

    var body: some View {
            List {
                ForEach(uniquePlants, id: \.id) { plant in
                    NavigationLink(destination: PlantDetailView(apiController: apiController, plant: plant)) {
                        PlantCellView(plant: plant)
                    }
                    .onAppear {
                        self.apiController.loadMoreContentIfNeeded(currentItem: plant)
                    }
                }
            }
        // .listStyle(.plain)  this is for removing the gray gap at the top of the list
            .onAppear {
                self.apiController.currentDistributionZone = self.selectedZone // Set the current distribution zone
                self.apiController.fetchPlantList(fromDistributionZone: selectedZone)
            }
    }
}
