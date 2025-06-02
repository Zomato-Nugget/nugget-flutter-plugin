<<<<<<< HEAD
// swift-tools-version:5.7
=======
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
import PackageDescription

let package = Package(
    name: "nugget_flutter_plugin",
    platforms: [
<<<<<<< HEAD
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "nugget_flutter_plugin",
            targets: ["nugget_flutter_plugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/zomato/nugget-ios-sdk.git", from: "1.0.0")
=======
        .iOS("14.0")
    ],
    products: [
        .library(name: "nugget-flutter-plugin", targets: ["nugget_flutter_plugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/BudhirajaRajesh/NuggetSDK.git", from: "1.1.13"),
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
    ],
    targets: [
        .target(
            name: "nugget_flutter_plugin",
            dependencies: [
<<<<<<< HEAD
                .product(name: "NuggetSDK", package: "nugget-ios-sdk")
            ]),
        .testTarget(
            name: "nugget_flutter_pluginTests",
            dependencies: ["nugget_flutter_plugin"]),
    ]
) 
=======
                .product(name: "NuggetSDK", package: "NuggetSDK"),
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
