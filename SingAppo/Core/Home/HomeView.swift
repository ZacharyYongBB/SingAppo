//
//  HomeView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeView()
}
