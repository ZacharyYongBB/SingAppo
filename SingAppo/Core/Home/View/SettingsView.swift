//
//  SettingsView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var listItems: [(String, AnyView, Bool)]
    
    var body: some View {
        List {
            ForEach(0..<listItems.count, id: \.self) { index in
                Toggle(isOn: Binding(
                    get: { listItems[index].2 },
                    set: { listItems[index].2 = $0 }
                )) {
                    Text(listItems[index].0)
                }
            }
        }
        .navigationTitle("Customize List")
    }
}


