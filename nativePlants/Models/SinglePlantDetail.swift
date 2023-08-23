import Foundation

struct PlantDetailResponse: Codable {
    let data: PlantDetail
}

struct PlantDetail: Codable {
    let id: Int
    let common_name: String
    let slug: String
    let scientific_name: String?
    let main_species_id: Int
    let image_url: String?
    let year: Int?
    let bibliography: String?
    let author: String?
    let family_common_name: String?
    let genus_id: Int?
    let observations: String
    let vegetable: Bool?
    let links: DetailedPlantLinks
    let main_species: MainSpecies
    let genus: Genus
    let family: Family
    let species: [Species]
    
    // the following lines are commented out due to the difficulty of the data returned
    // let subspecies: [SubSpecies]
    // let varieties: [Varieties]
    // let hybrids: [Hybrids]
    // let forms: [Forms]
    // let subvarieties: [SubVarieties]
    // let sources: [Sources]
}

struct DetailedPlantLinks: Codable {
    enum CodingKeys: String, CodingKey {
        case linkToPlant_Self = "self"
        case species
        case genus
    }
    
    let linkToPlant_Self: String?
    let species: String?
    let genus: String?
}


struct MainSpecies: Codable {
    let id: Int
    let common_name: String
    let slug: String
    let scientific_name: String
    let year: Int
    let bibliography: String
    let author: String
    let status: String
    let rank: String
    let family_common_name: String?
    let genus_id: Int
    let observations: String
    let vegetable: Bool?
    let image_url: String
    let genus: String
    let family: String
    // let duration: null,
    // edible_part: null,
    let edible: Bool?
    let images: Images
    // let common_names is a big list of names from different regions and languages
    let distribution: Distribution
}

struct Images: Codable {
    let flower: [Flower]?
    let leaf: [Leaf]
    let fruit: [Fruit]
    let bark: [Bark]
    let habit: [Habit]
    
    
    struct Flower: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
    
    struct Leaf: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
    
    struct Fruit: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
    
    struct Bark: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
    
    struct Habit: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
    
    // there exists another struct between these two in the JSON that is simply "" { (it also holds id, image url and copyright }, but i have no idea how to write it into a struct since it is two quotation marks.
    
    struct Other: Codable {
        let id: Int
        let image_url: String
        let copyright: String
    }
}

struct Genus: Codable {
    let id: Int
    let name: String
    let slug: String
    let links: Links
    
    struct Links: Codable {
        enum CodingKeys: String, CodingKey {
            case genusForPlant_Self = "self"
            case plants
            case species
            case family
        }
        
        let genusForPlant_Self: String
        let plants: String
        let species: String
        let family: String
    }
}

struct Family: Codable {
    let id: Int
    let name: String
    // let common_name: null
    let slug: String
    let links: Links
    
    struct Links: Codable {
        enum CodingKeys: String, CodingKey {
            case familyForPlant_Self = "self"
            case genus
        }
        
        let familyForPlant_Self: String
        // let division_order: null
        let genus: String
    }
}

struct Species: Codable {
    struct aZeroForSomeReason: Codable {
        let id: Int
        let common_name: String
        let slug: String
        let scientific_name: String
        let year: Int
        let bibliography: String
        let author: String
        let status: String
        let rank: String
        // let family_common_name: null
        let genus_id: Int
        let image_url: String
        // let synonyms: [Synonyms] <--! these are just numbered by entry, like 0, 1, 2 and so on for however many synonyms there are of it
        let genus: String
        let family: String
        let links: [Links]

        struct Links: Codable {
            enum CodingKeys: String, CodingKey {
                case speciesForPlant_Self = "self"
                case plant
                case genus
            }
            
            let speciesForPlant_Self: String
            let plant: String
            let genus: String
        }
    }
}

struct Distribution: Codable {
    let native: [String]
    let introduced: [String]
    let doubtful: [String]?
}


// the following structs have been commented out and provided reasonings are held within the structs
//struct SubSpecies {
//    // this is also just numbered entries for however many subspecies there are, an non-set amount.
//}
//
//struct Varieties {
//    // with barnyard grass an empty array was returned.
//}
//
//struct Hybrids {
//    // with barnyard grass an empty array was returned.
//
//}
//
//struct Forms {
//    // with barnyard grass an empty array was returned.
//
//}
//
//struct SubVarieties {
//    // with barnyard grass an empty array was returned.
//
//}
//
//struct Sources {
//    // this is also just numbered entries for however many subspecies there are, an non-set amount.
//
//}
