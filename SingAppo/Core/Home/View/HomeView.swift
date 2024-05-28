//
//  HomeView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.router) var router
    
    var body: some View {
        List {
            Button("SG Pools") {
                router.showScreen(.push) { _ in
                    SgPoolsView()
                }
            }
            Button("Bluetooth Scanner") {
                router.showScreen(.push) { _ in
                    BluetoothView()
                }
            }
        }
        .navigationTitle("What do you want")
    }
}

#Preview {
    HomeView()
}
