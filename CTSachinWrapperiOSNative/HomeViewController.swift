//
//  HomeViewController.swift
//  CTSachinWrapperiOSNative
//
//  App Home — displays the LP Wrapper SDK banner and Login / Logout buttons.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: — UI Elements

    private let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "This is Sachin's LP Wrapper SDK"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        config.baseBackgroundColor = UIColor.systemGreen
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 40, bottom: 14, trailing: 40)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let logoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Logout"
        config.baseBackgroundColor = UIColor.systemRed
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 40, bottom: 14, trailing: 40)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: — Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CTSachinWrapperiOSNative"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActions()
    }

    // MARK: — Layout

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [bannerLabel, loginButton, logoutButton])
        stack.axis = .vertical
        stack.spacing = 28
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            loginButton.widthAnchor.constraint(equalToConstant: 220),
            logoutButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }

    // MARK: — Actions

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }

    @objc private func logoutTapped() {
        let logoutVC = LogoutViewController()
        navigationController?.pushViewController(logoutVC, animated: true)
    }
}
