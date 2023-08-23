import Foundation
import Combine

class APIController: ObservableObject {
    var currentDistributionZone: String = ""
    
    private var plantListPublisher: AnyPublisher<PlantList, Error>?
    private var plantDetailPublisher: AnyPublisher<PlantDetail, Error>?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var plants: [Plant] = []
    @Published var plantDetail: PlantDetail?
    
    @Published var currentPage = 1
    @Published var isLoadingPage = false
    
    private var baseUrl = "https://trefle.io/api/v1/"
    private var token = "nnVcvYtNoWnb2Udxs4upkjiYftZwbljX6X52h-XCBtI"
    
    func fetchPlantList(fromDistributionZone distributionZone: String) {
        currentDistributionZone = distributionZone
        guard let url = URL(string: "\(baseUrl)distributions/\(distributionZone)/plants?token=\(token)&page=\(currentPage)") else {
            print("Invalid URL")
            return
        }
    
        plantListPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlantList.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        plantListPublisher?.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error: \(error)")
            }
        }, receiveValue: { [weak self] plantList in
//            self?.plants = plantList.data
            self?.plants.append(contentsOf: plantList.data)

        })
        .store(in: &cancellables)
    }
    
    func loadMoreContentIfNeeded(currentItem: Plant?) {
        guard let currentItem = currentItem,
              let lastItem = plants.suffix(15).first,
              !isLoadingPage,
              currentItem.id == lastItem.id else {
            return
        }
        
        currentPage += 1
        fetchPlantList(fromDistributionZone: currentDistributionZone)
    }

    func fetchPlantDetail(plantID: Int) {
        guard let url = URL(string: "\(baseUrl)plants/\(plantID)?token=\(token)") else {
            print("Invalid URL")
            return
        }

        let decoder = JSONDecoder()
       // decoder.keyDecodingStrategy = .convertFromSnakeCase

        plantDetailPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
        // this allows for printing of the json string
            .map{data in
                let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                // print(prettyPrintedString!)
                return data
            }
            .decode(type: PlantDetailResponse.self, decoder: decoder)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        plantDetailPublisher?.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error: \(error) LOOK ABOVE DUMMY")
            }
        }, receiveValue: { [weak self] plantDetail in
            self?.plantDetail = plantDetail
        })
        .store(in: &cancellables)
    }
    
    func cancelAllTasks() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // for clearing details for showing proper images
    func clearPlantDetails() {
        self.plantDetail = nil
    }
}
