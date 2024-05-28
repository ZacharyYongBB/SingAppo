//
//  NetworkConnectionManager.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import Foundation
import Network

class NetworkConnectionManager {
    static let shared = NetworkConnectionManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
    }

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = (path.status == .satisfied)
            print("Network status changed: \(self.isConnected)")
        }
        monitor.start(queue: queue)
    }
}
