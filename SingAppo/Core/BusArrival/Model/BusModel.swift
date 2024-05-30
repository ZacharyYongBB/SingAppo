//
//  BusModel.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import Foundation

struct BusArrivalResponse: Codable {
    let busStopCode: String
    let services: [BusServiceModel]

    enum CodingKeys: String, CodingKey {
        case busStopCode = "BusStopCode"
        case services = "Services"
    }
}

struct BusServiceModel: Codable {
    let serviceNo, busServiceModelOperator: String?
    let nextBus, nextBus2, nextBus3: NextBus?

    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case busServiceModelOperator = "Operator"
        case nextBus = "NextBus"
        case nextBus2 = "NextBus2"
        case nextBus3 = "NextBus3"
    }
}

struct NextBus: Codable {
    let originCode, destinationCode: String?
    let estimatedArrival: String?  // Changed to String
    let latitude, longitude, visitNumber, load: String?
    let feature, type: String?

    enum CodingKeys: String, CodingKey {
        case originCode = "OriginCode"
        case destinationCode = "DestinationCode"
        case estimatedArrival = "EstimatedArrival"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case visitNumber = "VisitNumber"
        case load = "Load"
        case feature = "Feature"
        case type = "Type"
    }
}
