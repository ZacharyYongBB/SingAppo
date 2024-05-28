//
//  RootView.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var networkStatus = NetworkStatus()
    
    var body: some View {
        VStack {
            if networkStatus.isConnected {
                Text("We have internet connection!")
                    .foregroundColor(.green)
            } else {
                Text("No internet connection.")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    RootView()
}
