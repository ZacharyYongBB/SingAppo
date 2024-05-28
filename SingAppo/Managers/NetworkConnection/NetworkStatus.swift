//
//  NetworkStatus.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import Foundation
import Combine

class NetworkStatus: ObservableObject {
    @Published var isConnected: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        isConnected = NetworkConnectionManager.shared.isConnected
        cancellable = NotificationCenter.default.publisher(for: .networkStatusChanged)
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isConnected = NetworkConnectionManager.shared.isConnected
                }
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
