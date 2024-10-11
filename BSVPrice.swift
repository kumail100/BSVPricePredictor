// BSVPrice.swift

import Foundation

struct BSVPriceResponse: Codable {
    let data: [BSVPriceData]
}

struct BSVPriceData: Codable {
    let time: String
    let price: Double
}
