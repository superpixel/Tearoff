//
//  ActionView.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 23.09.2026.
//

import SwiftUI

struct ActionView: View {
    @Environment(TearoffModel.self) private var model

    var body: some View {
        switch model.appState {
        case .start:
            HStack {
                Spacer()
                Button("Remove Quarantine", role: .destructive) {
                    model.removeQuarantine()
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
        case .clear:
            HStack {
                Label("Clear", systemImage: "shield")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Remove Quarantine", role: .destructive) {
                    model.removeQuarantine()
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
        case .quarantined:
            HStack {
                Label("Quarantined", systemImage: "shield.lefthalf.filled")
                    .foregroundStyle(.yellow)
                Spacer()
                Button("Remove Quarantine", role: .destructive) {
                    model.removeQuarantine()
                }
                .buttonStyle(.bordered)
            }
        case .error:
            HStack {
                Label("Unknown", systemImage: "questionmark")
                    .foregroundStyle(.red)
                Spacer()
                Button("Remove Quarantine", role: .destructive) {
                    model.removeQuarantine()
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }

        }
    }
}

#Preview("Start") {
    ActionView()
        .environment(TearoffModel(appState: .start))
        .padding()
}

#Preview("Clear") {
    ActionView()
        .environment(TearoffModel(appState: .clear))
        .padding()
}

#Preview("Quarantined") {
    ActionView()
        .environment(TearoffModel(appState: .quarantined))
        .padding()
}

#Preview("Error") {
    ActionView()
        .environment(TearoffModel(appState: .error))
        .padding()
}
