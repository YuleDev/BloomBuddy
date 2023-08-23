import Foundation
import SwiftUI

@main
struct nativePlantsApp: App {
    let persistenceController = PersistenceController.shared
    let imageCache = ImageCache()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(imageCache)
        }
    }
}
