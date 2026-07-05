//
//  AppDelegate.swift
//  CTSachinWrapperiOSNative
//
//  Leanplum Wrapper SDK - Basic Integration
//

import UIKit
import Leanplum

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // MARK: — Leanplum Verbose Logging
        // Enable verbose/debug logging BEFORE starting the SDK
        Leanplum.setLogLevel(.debug)

        // MARK: — Leanplum SDK Initialisation
        // Use Development key in DEBUG builds; swap to Production key for App Store builds
        #if DEBUG
            Leanplum.setAppId(
                "app_HXMTd0HjBpqxZtpIuCMQDcDtpWY1rKhN2X1QxJaC5Fo",
                developmentKey: "dev_SZE2XYsrBN5a8550ntXdIlEH9EYxVXIi6I8u3PRnlpo"
            )
        #else
            // TODO: Replace with your Production key before App Store submission
            Leanplum.setAppId(
                "app_HXMTd0HjBpqxZtpIuCMQDcDtpWY1rKhN2X1QxJaC5Fo",
                withProductionKey: "YOUR_PRODUCTION_KEY_HERE"
            )
        #endif

        // Optionally pin an app version (defaults to CFBundleVersion)
        Leanplum.setAppVersion("1.0.0")

        // Start a new Leanplum session — call after setting keys
        Leanplum.start()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
