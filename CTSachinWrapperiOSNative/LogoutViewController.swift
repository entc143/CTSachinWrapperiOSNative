//
//  LogoutViewController.swift
//  CTSachinWrapperiOSNative
//
//  Leanplum integration:
//    • Snapshots UserDefaults before & after deletion into a timestamped .txt file
//    • Clears all UserDefaults for the app's suite
//    • Tracks event "LPWrapperSDKLoggedOut"
//

import UIKit
import Leanplum

class LogoutViewController: UIViewController {

    // MARK: — UI

    private let congratsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congradulation, you are logged out successfully."
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sdkStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Clearing UserDefaults & tracking logout event..."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: — Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Logout"
        view.backgroundColor = .systemBackground
        setupLayout()
        performLeanplumLogoutTracking()
    }

    // MARK: — Layout

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [congratsLabel, sdkStatusLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }

    // MARK: — Logout

    private func performLeanplumLogoutTracking() {

        // 1. Snapshot UserDefaults BEFORE deletion
        let beforeSnapshot = UserDefaults.standard.dictionaryRepresentation()

        // 2. Delete all UserDefaults
        clearAllUserDefaults()

        // 3. Snapshot UserDefaults AFTER deletion
        let afterSnapshot = UserDefaults.standard.dictionaryRepresentation()

        // 4. Write both snapshots to a .txt log file
        writeUserDefaultsLog(before: beforeSnapshot, after: afterSnapshot)

        // 5. Track logout event
        Leanplum.track("LPWrapperSDKLoggedOut")

        sdkStatusLabel.text = "UserDefaults cleared, log saved & event 'LPWrapperSDKLoggedOut' tracked ✓"
    }

    // MARK: — UserDefaults

    /// Removes every key/value pair written by this app to the standard UserDefaults suite.
    private func clearAllUserDefaults() {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            UserDefaults.standard.dictionaryRepresentation().keys.forEach {
                UserDefaults.standard.removeObject(forKey: $0)
            }
            UserDefaults.standard.synchronize()
            return
        }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
        UserDefaults.standard.synchronize()
        print("[CTSachinWrapper] UserDefaults cleared for bundle: \(bundleID)")
    }

    // MARK: — Log File

    /// Writes a before/after snapshot of UserDefaults to a timestamped .txt file.
    /// Primary destination: project folder (works in Simulator).
    /// Fallback: app's Documents directory (works on real device).
    private func writeUserDefaultsLog(before: [String: Any], after: [String: Any]) {

        let timestamp = ISO8601DateFormatter().string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: ".", with: "-")

        var log = """
        ============================================================
        CTSachinWrapperiOSNative — UserDefaults Log
        Timestamp : \(timestamp)
        Bundle ID : \(Bundle.main.bundleIdentifier ?? "unknown")
        ============================================================

        >>> BEFORE DELETE (\(before.count) keys) <<<
        """

        if before.isEmpty {
            log += "\n  (no keys found)\n"
        } else {
            for key in before.keys.sorted() {
                log += "\n  \(key) = \(before[key]!)"
            }
            log += "\n"
        }

        log += """

        >>> AFTER DELETE (\(after.count) keys) <<<
        """

        if after.isEmpty {
            log += "\n  (empty — all keys removed successfully)\n"
        } else {
            for key in after.keys.sorted() {
                log += "\n  \(key) = \(after[key]!)"
            }
            log += "\n"
        }

        log += "\n============================================================\n"

        let fileName = "UserDefaults_Log_\(timestamp).txt"

        // --- Primary: write to project folder (accessible from Simulator on Mac) ---
        let projectPath = "/Users/sachin.gajbhiye/Claude/Projects/CTSachinWrapperiOSNative 2/\(fileName)"
        let projectURL = URL(fileURLWithPath: projectPath)

        do {
            try log.write(to: projectURL, atomically: true, encoding: .utf8)
            print("[CTSachinWrapper] ✅ UserDefaults log saved to project folder:\n  \(projectPath)")
            return
        } catch {
            print("[CTSachinWrapper] ⚠️ Could not write to project path (\(error.localizedDescription)). Falling back to Documents.")
        }

        // --- Fallback: app's Documents directory (always works, on device too) ---
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fallbackURL = docsURL.appendingPathComponent(fileName)

        do {
            try log.write(to: fallbackURL, atomically: true, encoding: .utf8)
            print("[CTSachinWrapper] ✅ UserDefaults log saved to Documents:\n  \(fallbackURL.path)")
        } catch {
            print("[CTSachinWrapper] ❌ Failed to save log: \(error.localizedDescription)")
        }
    }
}
