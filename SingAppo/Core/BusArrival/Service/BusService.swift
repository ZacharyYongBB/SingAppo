//
//  BusArrivalManager.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import Foundation

struct BusService: Codable, Identifiable {
    let id = UUID()
    let serviceNo: String
    let nextBus: String

    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case nextBus = "NextBus"
    }
}

struct BusArrivalResponse: Codable {
    let services: [BusService]

    enum CodingKeys: String, CodingKey {
        case services = "Services"
    }
}
