// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.4.0"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.7.0"),
        .package(name: "flutter_appauth", path: "../.packages/flutter_appauth-12.0.0"),
        .package(name: "flutter_localization", path: "../.packages/flutter_localization-0.4.0"),
        .package(name: "google_sign_in_ios", path: "../.packages/google_sign_in_ios-6.3.0"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+6"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "flutter-appauth", package: "flutter_appauth"),
                .product(name: "flutter-localization", package: "flutter_localization"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
