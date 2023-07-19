import Foundation
import SwiftUI

struct PlantListView: View {
    @ObservedObject var apiController: APIController

    var body: some View {
        NavigationView {
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
                self.apiController.fetchPlantList(fromDistributionZone: "UTA")
            }
        }
    }
}
