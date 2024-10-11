// PricePredictor.swift

import Foundation
import CoreML

class PricePredictor {
    private var model: BSVPricePredictor
    
    init() {
        // Initialize the CoreML model
        guard let model = try? BSVPricePredictor(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load BSVPricePredictor model")
        }
        self.model = model
    }
    
    func predictNextPrice(from prices: [BSVPriceData]) -> Double? {
        // Ensure there is enough data
        guard prices.count >= 30 else { return nil }
        
        // Prepare input for the model
        // This example assumes the model expects an array of 30 prices
        let sortedPrices = prices.sorted { $0.time < $1.time }
        let recentPrices = sortedPrices.suffix(30).map { $0.price }
        
        // Convert to MLMultiArray
        guard let inputArray = try? MLMultiArray(shape: [30] as [NSNumber], dataType: .double) else {
            print("Failed to create MLMultiArray")
            return nil
        }
        
        for (index, price) in recentPrices.enumerated() {
            inputArray[index] = NSNumber(value: price)
        }
        
        // Make prediction
        guard let prediction = try? model.prediction(input: BSVPricePredictorInput(input: inputArray)) else {
            print("Prediction failed")
            return nil
        }
        
        return prediction.output.doubleValue
    }
}
