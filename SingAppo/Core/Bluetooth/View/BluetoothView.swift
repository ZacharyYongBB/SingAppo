//
//  BluetoothView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct BluetoothView: View {
    
    @ObservedObject private var vm = BluetoothViewModel()
    
    var body: some View {
        List(vm.peripheralNames, id: \.self) { peripheral in
            Text(peripheral)
        }
        .navigationTitle("Bluetooth Devices")
    }
}

#Preview {
    BluetoothView()
}
