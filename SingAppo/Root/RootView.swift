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
    @Environment(\.router) var router
    @State private var showSignInView: Bool = false
    @State var selectedTab: Int = 0
    
    
    var body: some View {
        
        ZStack {
            if !showSignInView {
//                TabView(selection: $selectedTab) {
//                    RouterView { _ in
//                        HomeView(showSignInView: $showSignInView)
//                    }
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                        Text("Home")
//                    }
//                    .tag(0)
//                    ProfileView(showSignInView: $showSignInView)
//                        .tabItem {
//                            Image(systemName: "person.fill")
//                            Text("Profile")
//                        }
//                        .tag(1)
//                }
                ProductsView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            try? print(AuthenticationManager.shared.getProviders())
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

#Preview {
    RootView()
}
