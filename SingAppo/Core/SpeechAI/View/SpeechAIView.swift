//
//  SpeechAIView.swift
//  SingAppo
//
//  Created by Zachary on 29/5/24.
//

import SwiftUI
import SiriWaveView

struct SpeechAIView: View {
    
    @State var speechVM = SpeechAIViewModel()
    @State var isSymbolAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("AI Voice Assistant")
                .font(.largeTitle)
            
            Spacer()
            SiriWaveView()
                .power(power: speechVM.audioPower)
                .opacity(speechVM.siriWaveFormOpacity)
                .frame(height: 256)
                .overlay { overlayView }
            Spacer()
            
            switch speechVM.state {
            case .recordingSpeech:
                cancelRecordingButton
            case .playingSpeech, .processingSpeech:
                cancelButton
            default: EmptyView()
            }
            
            
            
            Picker("Select Voice", selection: $speechVM.selectedVoice) {
                ForEach(VoiceType.allCases, id: \.self) {
                    Text($0.rawValue).id($0)
                }
            }
            .pickerStyle(.palette)
            .disabled(!speechVM.isIdle)
            
            if case let .error(error) = speechVM.state {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding(10)
        
    }
    
    @ViewBuilder
    var overlayView: some View {
        switch speechVM.state {
        case.idle, .error:
            startRecordButton
        case.processingSpeech:
            Image(systemName: "brain.head.profile.fill")
                .symbolEffect(.bounce.up.byLayer, options: .repeating, value: isSymbolAnimating)
                .font(.system(size: 128))
                .onAppear {
                    isSymbolAnimating = true
                }
                .onDisappear {
                    isSymbolAnimating = false
                }
        default: EmptyView()
        }
    }
    
    var startRecordButton: some View {
        Button {
            speechVM.startCaptureAudio()
        } label: {
            Image(systemName: "mic.circle")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 128))
        }.buttonStyle(.borderless)
    }
    
    var cancelRecordingButton: some View {
        Button(role: .destructive) {
            speechVM.cancelRecording()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }
    
    var cancelButton: some View {
        Button(role: .destructive) {
            speechVM.cancelProcessingTask()
        } label: {
            Image(systemName: "stop.circle.fill")
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.red)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }
}





#Preview("Idle") {
    SpeechAIView()
}

#Preview("Recording Speech") {
    let vm = SpeechAIViewModel()
    vm.state = .recordingSpeech
    vm.audioPower = 0.2
    return SpeechAIView(speechVM: vm)
}

#Preview("Processing Speech") {
    let vm = SpeechAIViewModel()
    vm.state = .processingSpeech
    return SpeechAIView(speechVM: vm)
}

#Preview("Playing Speech") {
    let vm = SpeechAIViewModel()
    vm.state = .playingSpeech
    vm.audioPower = 0.3
    return SpeechAIView(speechVM: vm)
}

#Preview("Error") {
    let vm = SpeechAIViewModel()
    vm.state = .error("Error with speech")
    return SpeechAIView(speechVM: vm)
}
