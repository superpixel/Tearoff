//
//  HelpView.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 24.09.2026.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        let em = NSFont.preferredFont(forTextStyle: .body).pointSize
        
        ScrollView {
            VStack(alignment: .leading, spacing: em) {
                Text("Understand quarantine in macOS")
                    .font(.headline)
                Text("Quarantine is a technology built into macOS to mark items that arrive from sources off the device, such as web downloads, iMessages, or AirDrop. macOS adds metadata to the item regarding its origin to provide context during first-launch prompts.")

                Text("How Tearoff works")
                    .font(.headline)
                Text("Tearoff inspects and modifies quarantine properties on an item using the `quarantineProperties` URL resource key and displays `kLSQuarantineAgentNameKey` and `kLSQuarantineAgentBundleIdentifierKey`: which app downloaded the file (shown as 'Name (bundle ID)'); `kLSQuarantineTimeStampKey`: when it was downloaded; `kLSQuarantineTypeKey`: how it arrived, e.g. `LSQuarantineTypeWebDownload`.")

                Text("Alternatives")
                    .font(.headline)
                Text("You can use the `xattr` command line utility to check the quarantine information of an item:")
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quinary)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Label("Terminal", systemImage: "apple.terminal")
                            .labelStyle(.iconOnly)
                            .font(.title2)
//                            .foregroundStyle(.tint)
                        Text("`xattr -p com.apple.quarantine ~/Downloads/Example.zip`")
                    }
                    .padding(12)
                }
                Text("And delete quarantine information from an item with the `-d` option:")
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quinary)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Label("Terminal", systemImage: "apple.terminal")
                            .labelStyle(.iconOnly)
                            .font(.title2)
//                            .foregroundStyle(.tint)
                        Text("`xattr -d com.apple.quarantine ~/Downloads/Example.zip`")
                    }
                    .padding(12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .textSelection(.enabled)
//        .scrollBounceBehavior(.basedOnSize) /// Does not work correctly in macOS 27.0. Sometimes bounces, sometimes not.
    }
}

#Preview {
    HelpView()
        .frame(height: 500)
        .frame(maxWidth: 400)
}
