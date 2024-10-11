// ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var networkManager = NetworkManager()
    let predictor = PricePredictor()
    
    @State private var predictedPrice: Double?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bitcoin SV (BSV) Price Predictor")
                    .font(.title)
                    .padding()
                
                if networkManager.prices.isEmpty {
                    ProgressView("Fetching BSV Prices...")
                        .onAppear {
                            networkManager.fetchBSVPrices()
                        }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Price: $\(currentPrice(), specifier: "%.2f")")
                            .font(.headline)
                        
                        if let prediction = predictedPrice {
                            Text("Predicted Next Price: $\(prediction, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.green)
                        } else {
                            Text("Predicting next price...")
                                .font(.subheadline)
                                .onAppear {
                                    self.predictedPrice = predictor.predictNextPrice(from: networkManager.prices)
                                }
                        }
                    }
                    .padding()
                    
                    // Optionally, display a chart or more detailed data
                }
                
                Spacer()
            }
            .navigationBarTitle("BSV Price Predictor", displayMode: .inline)
        }
    }
    
    func currentPrice() -> Double {
        return networkManager.prices.last?.price ?? 0.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
