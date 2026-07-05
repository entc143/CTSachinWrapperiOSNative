//
//  LoginViewController.swift
//  CTSachinWrapperiOSNative
//
//  Leanplum integration:
//    • Sets user ID on the Leanplum profile
//    • Sets user attributes (name, email, loginTime, platform)
//    • Tracks event "LPWrapperSDKLoggedIn"
//

import UIKit
import Leanplum

class LoginViewController: UIViewController {

    // MARK: — UI

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!, you are logged in user."
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sdkStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Leanplum: Tracking user profile & event..."
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
        title = "Login"
        view.backgroundColor = .systemBackground
        setupLayout()
        performLeanplumLoginTracking()
    }

    // MARK: — Layout

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, sdkStatusLabel])
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

    // MARK: — Leanplum

    private func performLeanplumLoginTracking() {

        // 1. Set User ID — identifies this user in the Leanplum profile
        Leanplum.setUserId("sachin_user_001")

        // 2. Set User Attributes — key/value pairs shown in the Leanplum User Profile
        let userAttributes: [AnyHashable: Any] = [
            "name":        "Sachin Gajbhiye",
            "email":       "sachin.gajbhiye@clevertap.com",
            "platform":    "iOS",
            "loginTime":   ISO8601DateFormatter().string(from: Date()),
            "appVersion":  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]
        Leanplum.setUserAttributes(userAttributes)

        // 3. Track login event
        Leanplum.track("LPWrapperSDKLoggedIn")

        sdkStatusLabel.text = "Leanplum: User profile set & event 'LPWrapperSDKLoggedIn' tracked ✓"
    }
}
