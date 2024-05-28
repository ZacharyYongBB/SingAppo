//
//  RootView.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import SwiftUI
import SwiftfulRouting

struct RootView: View {
    
    @StateObject private var networkStatus = NetworkStatus()
    
    var body: some View {
        RouterView { _ in
            TabView {
                SgPoolsView()
                    .tabItem {
                        Image(systemName: "dollarsign.circle")
                        Text("SG Pools")
                    }
            }
            
        }
        //        VStack {
        //            if networkStatus.isConnected {
        //                Text("We have internet connection!")
        //                    .foregroundColor(.green)
        //            } else {
        //                Text("No internet connection.")
        //                    .foregroundColor(.red)
        //            }
        //        }
    }
}

#Preview {
    RootView()
}
