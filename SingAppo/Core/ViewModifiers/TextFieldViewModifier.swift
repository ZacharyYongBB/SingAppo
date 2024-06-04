//
//  TextFieldViewModifier.swift
//  SingAppo
//
//  Created by Zachary on 4/6/24.
//

import SwiftUI

struct TextFieldViewModifier: ViewModifier {
    
    var kbType: UIKeyboardType?
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .keyboardType(kbType ?? .default)
        
    }
}

extension View {
    func primaryTextField(kbType: UIKeyboardType? = .default) -> some View {
        modifier(TextFieldViewModifier(kbType: kbType))
    }
}
