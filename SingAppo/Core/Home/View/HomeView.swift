//
//  HomeView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.router) var router
    @State private var listItems: [(String, AnyView, Bool)] = [
        ("SG Pools", AnyView(SgPoolsView()), true),
        ("Bluetooth Scanner", AnyView(BluetoothView()), true)
    ]
    
    var body: some View {
        List {
            ForEach(0..<listItems.count, id: \.self) { index in
                // .2 is the bool in the tuple if true = checked
                if listItems[index].2 {
                    Button(listItems[index].0) {
                        router.showScreen(.push) { _ in
                            listItems[index].1
                        }
                    }
                }
            }
        }
        .navigationTitle("What do you want")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        router.showScreen(.push) { _ in
                            SettingsView(listItems: $listItems)
                        }
                    }, label: {
                        Image(systemName: "gear")
                        Text("Customize")
                    })
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        HomeView()
    }
}
