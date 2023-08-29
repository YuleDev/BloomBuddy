import Foundation
import SwiftUI

struct DistributionZoneView: View {
    @State private var searchText = ""
    @State private var distributionZones: [DistributionZone] = {
        return loadDistributionZones()
    }()
    
    struct UserDefaultsKeys {
         static let selectedZone = "selectedZone"
     }

    var filteredDistributionZones: [DistributionZone] {
         distributionZones.filter { zone in
             searchText.isEmpty || zone.name.localizedStandardContains(searchText)
         }
     }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                List(filteredDistributionZones) { zone in
                    NavigationLink(destination: PlantListView(apiController: APIController(), selectedZone: zone.code)) {
                        Text("\(zone.name)")
                    }
                }
               .listStyle(.plain) // this is for removing the gray gap at the top of the list
            }
        }
    }
    
    func saveSelectedZone(zone: DistributionZone) {
        print("Saving zone: \(zone.name)") 
        UserDefaults.standard.set(zone.name, forKey: UserDefaultsKeys.selectedZone)
    }
}

func loadDistributionZones() -> [DistributionZone] {
    // sort the complete array
    let sortedDistributionZones = completeDistributionZonesArray.sorted { $0.name < $1.name }
    
    // sort the american array
    let sortedAmericanDistributionZone = americanDistributionZonesArray.sorted { $0.name < $1.name}
    
    // return the sorted array of choice
    return sortedAmericanDistributionZone
}
