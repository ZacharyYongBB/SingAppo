//
//  BusArrivalViewModel.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import Foundation

class BusArrivalViewModel: ObservableObject {
    
    @Published var busArrivalTimings: [BusServiceModel] = []
    
    func fetchBusArrival(busStopNo: Int) async throws -> [BusServiceModel] {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let baseURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=\(busStopNo)"
        guard let url = URL(string: baseURL) else {
            throw ErrorMessage.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(LTA_API_KEY, forHTTPHeaderField: "AccountKey")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        do {
            let busArrivalResponse = try decoder.decode(BusArrivalResponse.self, from: data)
            guard !busArrivalResponse.services.isEmpty else {
                return []
            }
            return busArrivalResponse.services
        } catch {
            throw ErrorMessage.invalidData
        }
    }
}







