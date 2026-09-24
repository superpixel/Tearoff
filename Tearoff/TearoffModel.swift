//
//  TearoffModel.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 23.09.2026.
//

import SwiftUI
//import AppKit
import Observation
import UniformTypeIdentifiers


enum AppState {
    case start
    case clear
    case quarantined
    case error
}

@Observable
final class TearoffModel {
    var appState: AppState
    var droppedURL: URL?

    /// Displayed information about the current item
    var icon: NSImage = NSWorkspace.shared.icon(for: .data)
    var fileName = ""
    var agent = TearoffModel.noValue
    var timeStamp = TearoffModel.noValue
    var type = TearoffModel.noValue

    /// Presentation state
    var isShowingFileImporter = false
    var removeError: Error?

    private static let noValue = String(localized: "None")

    /// Needed for the #Previews to work with different AppState
    init(appState: AppState = .start) {
        self.appState = appState
    }

    /// Adds an item and reads its quarantine information.
    /// Replaces the currently added item, if any.
    func add(_ url: URL) {
        reset()

        droppedURL = url
        icon = NSWorkspace.shared.icon(forFile: url.path(percentEncoded: false))
        fileName = url.lastPathComponent

        updateQuarantineStatus()
    }

    /// Removes the current item and returns to the start state.
    func reset() {
        droppedURL = nil
        icon = NSWorkspace.shared.icon(for: .data)
        fileName = ""
        agent = Self.noValue
        timeStamp = Self.noValue
        type = Self.noValue
        appState = .start
    }

    func removeQuarantine() {
        guard let droppedURL else { return }

        do {
            // Setting `URLResourceValues.quarantineProperties` to nil doesn't
            // remove the attribute, because the nil value is never passed on.
            // NSURL with NSNull explicitly removes the quarantine properties.
            try (droppedURL as NSURL).setResourceValue(NSNull(), forKey: .quarantinePropertiesKey)

            // Verify, since the system may silently keep the attribute.
            if try readQuarantineProperties(of: droppedURL) != nil {
                throw CocoaError(.fileWriteNoPermission, userInfo: [NSURLErrorKey: droppedURL])
            }
            updateQuarantineStatus()
        } catch {
            removeError = error
            updateQuarantineStatus()
        }
    }

    // MARK: - Private

    private func updateQuarantineStatus() {
        guard let droppedURL else { return }

        agent = Self.noValue
        timeStamp = Self.noValue
        type = Self.noValue

        do {
            guard let properties = try readQuarantineProperties(of: droppedURL) else {
                appState = .clear
                return
            }

            // Shows "Name (bundle identifier)", or whichever of both is available
            let agentName = properties[kLSQuarantineAgentNameKey as String] as? String
            let agentBundleIdentifier = properties[kLSQuarantineAgentBundleIdentifierKey as String] as? String
            switch (agentName, agentBundleIdentifier) {
            case let (name?, bundleIdentifier?):
                agent = "\(name) (\(bundleIdentifier))"
            case let (name?, nil):
                agent = name
            case let (nil, bundleIdentifier?):
                agent = bundleIdentifier
            case (nil, nil):
                break
            }
            if let value = properties[kLSQuarantineTimeStampKey as String] as? Date {
                timeStamp = value.formatted(date: .complete, time: .shortened)
            }
            if let value = properties[kLSQuarantineTypeKey as String] as? String {
                type = value
            }
            appState = .quarantined
        } catch {
            appState = .error
        }
    }

    /// Returns the quarantine properties, or nil if the item isn't quarantined.
    private func readQuarantineProperties(of url: URL) throws -> [String: Any]? {
        var url = url
        url.removeAllCachedResourceValues()
        return try url.resourceValues(forKeys: [.quarantinePropertiesKey]).quarantineProperties
    }
}
