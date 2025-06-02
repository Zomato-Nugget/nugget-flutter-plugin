// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "nugget_flutter_plugin",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "nugget_flutter_plugin",
            targets: ["nugget_flutter_plugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/zomato/nugget-ios-sdk.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "nugget_flutter_plugin",
            dependencies: [
                .product(name: "NuggetSDK", package: "nugget-ios-sdk")
            ]),
        .testTarget(
            name: "nugget_flutter_pluginTests",
            dependencies: ["nugget_flutter_plugin"]),
    ]
) 