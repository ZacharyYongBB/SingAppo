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
    
    private let tabViews: [AnyView] = [
        AnyView(HomeView().tabItem {
            Image(systemName: "house")
            Text("Home")
        }),
        AnyView(SgPoolsView().tabItem {
            Image(systemName: "dollarsign.circle")
            Text("SG Pools")
        })
        // Add more views here as needed
    ]
    
    var body: some View {
        RouterView { _ in
            TabView {
                ForEach(tabViews.indices, id: \.self) { index in
                    tabViews[index]
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
