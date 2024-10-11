// NetworkManager.swift

import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var prices: [BSVPriceData] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBSVPrices() {
        // Replace with a reliable BSV price API
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin-sv/market_chart?vs_currency=usd&days=30") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: BSVPriceResponse.self, decoder: JSONDecoder())
            .map { $0.data }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedPrices in
                self?.prices = fetchedPrices
            }
            .store(in: &cancellables)
    }
}
