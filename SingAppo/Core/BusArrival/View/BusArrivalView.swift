//
//  BusArrivalView.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import SwiftUI

import SwiftUI

struct BusArrivalView: View {
    
    @StateObject private var viewModel = BusArrivalViewModel()
    @State private var busStopNo: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Bus Stop Number", text: $busStopNo)
                .primaryTextField(kbType: .numberPad)
            
            Button(action: {
                Task {
                    do {
                        let busArrivalTimings = try await viewModel.fetchBusArrival(busStopNo: Int(busStopNo) ?? 0)
                        viewModel.busArrivalTimings = busArrivalTimings
                    } catch {
                        print("Error fetching bus arrival timings: \(error)")
                    }
                }
            }) {
                Text("Get Bus Arrivals")
                    .primaryButton()
            }
            
            List(viewModel.busArrivalTimings, id: \.serviceNo) { busService in
                VStack(alignment: .leading) {
                    Text("Bus \(busService.serviceNo ?? "")")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Next Arrival: \(formattedEstimatedArrival(busService.nextBus?.estimatedArrival))")
                        .foregroundColor(.secondary)
                    Text("Second Arrival: \(formattedEstimatedArrival(busService.nextBus2?.estimatedArrival))")
                        .foregroundColor(.secondary)
                    Text("Third Arrival: \(formattedEstimatedArrival(busService.nextBus3?.estimatedArrival))")
                        .foregroundColor(.secondary)
                }
            }
            .listStyle(.automatic)
        }
        .padding()
        .dismissKeyboardOnTap()
    }
    
}


#Preview {
    BusArrivalView()
}
