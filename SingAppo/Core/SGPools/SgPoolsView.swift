//
//  SwiftUIView.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import SwiftUI
import SwiftfulRouting

struct SgPoolsView: View {
    
    @StateObject private var vm = SgPoolsViewModel()
    
    @State private var totoNumbers: [Int]?
    @State private var fourDNumbers: String?
    
    var body: some View {
        VStack {
            Text("Toto Numbers")
            Button("generate Toto numbers") {
                totoNumbers = vm.generateToto()
            }
            
            if let totoNumbers = totoNumbers {
                ForEach(totoNumbers, id: \.self) { totoNo in
                    Text(String(totoNo))
                }
            }
            
            Spacer()
            
            Text("4d Numbers")
            Button("generate 4D numbers") {
                fourDNumbers = vm.generate4D()
            }
            if let fourDNumbers = fourDNumbers {
                Text(fourDNumbers)
            }
            Spacer()
            
        }
        .navigationTitle("SG Pools")
    }
}

#Preview {
    RouterView { _ in
        SgPoolsView()
    }
}
