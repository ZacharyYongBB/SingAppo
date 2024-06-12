//
//  TabbarView.swift
//  SingAppo
//
//  Created by Zachary on 12/6/24.
//

import SwiftUI
import SwiftfulRouting

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    @Environment(\.router) var router

    
    var body: some View {
        TabView {
            RouterView { _ in
                HomeView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
