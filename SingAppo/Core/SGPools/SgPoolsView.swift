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
            Button("generate ordinary entry") {
                totoNumbers = vm.generateToto(system: 6)
            }
            Button("generate system 7") {
                totoNumbers = vm.generateToto(system: 7)
            }
            Button("generate system 8") {
                totoNumbers = vm.generateToto(system: 8)
            }
            Button("generate system 9") {
                totoNumbers = vm.generateToto(system: 9)
            }
            Button("generate system 10") {
                totoNumbers = vm.generateToto(system: 10)
            }
            Button("generate system 11") {
                totoNumbers = vm.generateToto(system: 11)
            }
            Button("generate system 12") {
                totoNumbers = vm.generateToto(system: 12)
            }
            
            
            if let totoNumbers = totoNumbers {
                HStack {
                    ForEach(totoNumbers, id: \.self) { totoNo in
                        Text(String(totoNo))
                    }
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
