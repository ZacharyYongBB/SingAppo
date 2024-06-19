//
//  PerformanceView.swift
//  SingAppo
//
//  Created by Zachary on 20/6/24.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    
    @State private var title: String = "Some title"
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                
                PerformanceManager.shared.startTrace(traceName: "performanceStart")
            }
            .onDisappear {
                PerformanceManager.shared.stopTrace(traceName: "performanceStart")
            }
    }
    
    private func configure() {
        PerformanceManager.shared.startTrace(traceName: "performanceViewLoading")
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(traceName: "performanceViewLoading", value: "started", forAttribute: "funcState")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(traceName: "performanceViewLoading", value: "continuing", forAttribute: "funcState")

            try? await Task.sleep(nanoseconds: 2_000_000_000)
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(traceName: "performanceViewLoading", value: "finished", forAttribute: "funcState")

            PerformanceManager.shared.stopTrace(traceName: "performanceViewLoading")
        }
    }
    
    func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let metric = HTTPMetric(url: url, httpMethod: .get) else { return }
        metric.start()
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
                print("succ")
            } catch {
                print(error)
                metric.stop()
                
            }
        }
    }
    
}

#Preview {
    PerformanceView()
}
