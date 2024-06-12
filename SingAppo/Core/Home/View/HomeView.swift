//
//  HomeView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.router) var router
    @Binding var showSignInView: Bool
    @State private var vm = HomeViewModel()
    //    @State private var listItems: [(String, AnyView, Bool)] = [
    //        ("SG Pools", AnyView(SgPoolsView()), true),
    //        ("Bluetooth Scanner", AnyView(BluetoothView()), true),
    //        ("Ask AI", AnyView(SpeechAIView()), true),
    //        ("Bus Arrival", AnyView(BusArrivalView()), true),
    //    ]
    
    var body: some View {
        //        List {
        //            ForEach(0..<listItems.count, id: \.self) { index in
        //                // .2 is the bool in the tuple if true = checked
        //                if listItems[index].2 {
        //                    Button(listItems[index].0) {
        //                        router.showScreen(.push) { _ in
        //                            listItems[index].1
        //                        }
        //                    }
        //                }
        //            }
        //        }
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
            Button("Ask AI") {
                router.showScreen(.push) { _ in
                    SpeechAIView()
                }
            }
            Button("Bus Arrival") {
                router.showScreen(.push) { _ in
                    BusArrivalView()
                }
            }
            Button("Products") {
                router.showScreen(.push) { _ in
                    ProductsView()
                }
            }
        }
        .navigationTitle("What do you want")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    Task {
                        do {
                            try vm.logOut()
                            showSignInView = true
                        } catch {
                            // TODO: handle Error
                            print(error)
                        }
                    }
                } label: {
                    HStack {
                        Text("Log Out")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.showScreen(.push) { _ in
                        SettingsView(
                            showSignInView: $showSignInView
                            // ,listItems: $listItems
                        )
                    }
                } label: {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .font(.headline)
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        HomeView(showSignInView: .constant(false))
    }
}
