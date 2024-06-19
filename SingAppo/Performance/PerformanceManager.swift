//
//  PerformanceManager.swift
//  SingAppo
//
//  Created by Zachary on 20/6/24.
//

import Foundation
import FirebasePerformance

final class PerformanceManager {
    
    static let shared = PerformanceManager()
    private init() { }
    
    var traces: [String: Trace] = [:]
    
    func startTrace(traceName: String) {
        let trace = Performance.startTrace(name: traceName)
        traces[traceName] = trace
    }
    
    func setValue(traceName: String, value: String, forAttribute: String) {
        guard let trace = traces[traceName] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    
    func stopTrace(traceName: String) {
        guard let trace = traces[traceName] else { return }
        trace.stop()
        traces.removeValue(forKey: traceName)
    }
    
}
