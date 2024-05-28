//
//  SwiftUIView.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulUI

struct SgPoolsView: View {
    
    @StateObject private var vm = SgPoolsViewModel()
    
    @State private var totoNumbers: [Int]?
    @State private var fourDNumbers: String?
    
    var body: some View {
        ScrollView {
            Text("Toto Numbers")
            ForEach(6...12, id: \.self) { system in
                Button(action: {
                    totoNumbers = vm.generateToto(system: system)
                }) {
                    Text("Generate System \(system)")
                        .primaryButton()
                }
            }
            
            
            if let totoNumbers = totoNumbers {
                NonLazyVGrid(
                    columns: 6,
                    alignment: .center,
                    spacing: 16,
                    items: totoNumbers
                ) { number in
                    if let number {
                        Text(String(number))
                            .font(.headline)
                            .padding(5)
                            .background(Color.yellow)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Text("4d Numbers")
            Button(action: {
                fourDNumbers = vm.generate4D()
                
            }, label: {
                Text("Generate 4D")
                    .primaryButton()
            })
            if let fourDNumbers = fourDNumbers {
                Text(fourDNumbers)
                    .font(.title)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
            Spacer()
            
        }
        .padding()
        .navigationTitle("SG Pools")
    }
}

#Preview {
    RouterView { _ in
        SgPoolsView()
    }
}
