import Foundation
import SwiftUI

class ImageCache: ObservableObject {
    @Published private(set) var cache = [String: UIImage]()

    func get(for urlString: String) -> UIImage? {
        cache[urlString]
    }

    func add(_ image: UIImage, for urlString: String) {
        cache[urlString] = image
    }
}
