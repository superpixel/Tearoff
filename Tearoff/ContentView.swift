//
//  ContentView.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 22.09.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(TearoffModel.self) private var model
    
    var body: some View {
        @Bindable var model = model

        VStack(alignment: .leading, spacing: 16) {
            ItemView()
            ActionView()
        }
        .padding()
        .fileImporter(isPresented: $model.isShowingFileImporter, allowedContentTypes: [.item, .folder]) { result in
            if case .success(let url) = result {
                model.add(url)
            }
        }
        // Items dropped on the app icon or opened via Finder's "Open With"
        .onOpenURL { url in
            model.add(url)
        }
        .alert(
            "Quarantine could not be removed",
            isPresented: Binding(
                get: { model.removeError != nil },
                set: { if !$0 { model.removeError = nil } }
            ),
            presenting: model.removeError
        ) { _ in
            Button("OK") { }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}

#Preview("Default") {
    ContentView()
        .environment(TearoffModel())
}

#Preview("Quarantined") {
    ContentView()
        .environment(TearoffModel(appState: .quarantined))
        .padding()
}
