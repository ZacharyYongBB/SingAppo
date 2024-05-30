//
//  DismissKeyboardOnTapModifier.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import SwiftUI

struct DismissKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                TapGestureView()
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

struct TapGestureView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func handleTap() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTapModifier())
    }
}
