//
//  ButtonViewModifier.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI

struct ButtonViewModifier: ViewModifier {
    
    var btnColor: Color?
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(btnColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

extension View {
    func primaryButton(color: Color? = Color.blue) -> some View {
        modifier(ButtonViewModifier(btnColor: color))
    }
}
