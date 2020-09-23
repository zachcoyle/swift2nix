// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "example",
    dependencies: [
        .package(url: "https://github.com/flight-school/money", from: "1.2.0"),
        .package(url: "https://github.com/mattt/Euler", from: "1.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.0.1"),
        .package(url: "https://github.com/drewag/Decree", from: "4.3.0"),
    ],
    targets: [
        .target(
            name: "example",
            dependencies: ["Euler", "Money", "SwiftShell", "Decree"]),
        .testTarget(
            name: "exampleTests",
            dependencies: ["example"]),
    ]
)
