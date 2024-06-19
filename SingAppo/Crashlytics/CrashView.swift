//
//  CrashView.swift
//  SingAppo
//
//  Created by Zachary on 19/6/24.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 40) {
                Button("Crash") {
                  fatalError("Crash was triggered")
                }
                Button("Crash 2") {
                    CrashManager.shared.addLog(message: "Crash 2 clicked")
                    
                    let myString: String? = nil
                    let myString2 = myString!
                }
                
                Button("Crash 3") {
                    CrashManager.shared.addLog(message: "Crash 3 clicked")

                    let array: [String] = []
                    let item = array[0]
                }
                
                Button("Non fatal 4") {
                    let myString: String? = nil
                    guard let myString else { return }
                    CrashManager.shared.sendNonFatal(error: ErrorMessage.unableToComplete.rawValue + "User without myString tried to assign string")
                    let string = myString
                }
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "ccc321")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLog(message: "CrashView appeared")
        }
    }
}

#Preview {
    CrashView()
}
