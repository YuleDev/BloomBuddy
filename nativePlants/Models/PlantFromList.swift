import Foundation
import SwiftUI

struct Plant: Codable, Identifiable {
    let id: Int
    let commonName: String?
    let scientificName: String
    let synonyms: [String]?
    let family: String
    let genus: String
    let imageURL: String?
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case synonyms
        case family
        case genus
        case imageURL = "image_url"
        case links
    }
    
    struct Links: Codable {
        let selfLink: String
        let plant: String
        let genus: String
        
        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case plant
            case genus
        }
    }
}

extension Plant: Hashable {
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
