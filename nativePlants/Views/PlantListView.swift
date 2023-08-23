import Foundation
import SwiftUI

struct PlantListView: View {
    @ObservedObject var apiController: APIController
    var selectedZone: String

    var body: some View {
            List {
                ForEach(apiController.plants, id: \.id) { plant in
                    NavigationLink(destination: PlantDetailView(apiController: apiController, plant: plant)) {
                        PlantCellView(plant: plant)
                    }
                    .onAppear {
                        self.apiController.loadMoreContentIfNeeded(currentItem: plant)
                    }
                }
            }
            .onAppear {
                self.apiController.currentDistributionZone = self.selectedZone // Set the current distribution zone
                self.apiController.fetchPlantList(fromDistributionZone: selectedZone)
            }
    }
}
