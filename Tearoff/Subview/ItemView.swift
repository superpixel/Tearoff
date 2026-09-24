//
//  ItemView.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 23.09.2026.
//

import SwiftUI

struct ItemView: View {
    @Environment(TearoffModel.self) private var model
    @State private var isDropTargeted = false

    var body: some View {
        VStack(spacing: 0) {
            if model.appState == .start {
                VStack(spacing: 10) {
                    Spacer()
                    Image("circle.dotted.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 32)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.secondary, .tertiary)
                    Text("Drop an item here to check \nits quarantine status")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 180)
                .foregroundStyle(.secondary)
            } else {
                VStack {
                    Spacer()
                    Image(nsImage: model.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 64)
                    VStack(spacing: 16) {
                        Text(model.fileName)
                            .fontWeight(.bold)
                            .truncationMode(.middle)
                            .lineLimit(1)
                            .help(model.fileName)

                        Grid(alignment: .trailingFirstTextBaseline, horizontalSpacing: 6, verticalSpacing: 6) {
                            GridRow {
                                Text("Agent:")
                                    .foregroundStyle(.secondary)
                                Text(model.agent)
                                    .gridColumnAlignment(.leading)
                                    .frame(minWidth: 64, alignment: .leading)
                            }

                            GridRow {
                                Text("Time stamp:")
                                    .foregroundStyle(.secondary)
                                Text(model.timeStamp)
                            }

                            GridRow {
                                Text("Type:")
                                    .foregroundStyle(.secondary)
                                Text(model.type)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .font(.callout)
                        .frame(maxWidth: .infinity)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.075))
                .strokeBorder(isDropTargeted ? Color.accentColor : Color.clear, lineWidth: 2)
        }
        .dropDestination(for: URL.self) { urls, _ in
            guard let url = urls.first else { return false }
            model.add(url)
            return true
        } isTargeted: {
            isDropTargeted = $0
        }
    }
}

#Preview("Start") {
    ItemView()
        .environment(TearoffModel(appState: .start))
        .padding()
}

#Preview("Quarantined") {
    ItemView()
        .environment(TearoffModel(appState: .quarantined))
        .padding()
}
