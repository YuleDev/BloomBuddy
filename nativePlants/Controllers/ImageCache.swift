import Foundation
import SwiftUI

class ImageCache: ObservableObject {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    func add(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
    
    func get(for url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }
}
