//
//  ProfileView.swift
//  SingAppo
//
//  Created by Zachary on 7/6/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "gear")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
