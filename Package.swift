// swift-tools-version:5.10

import PackageDescription
import Foundation

let package = Package(
    name: "CoreDataRepository",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "CoreDataRepository",
            targets: ["CoreDataRepository"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump.git",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "CoreDataRepository",
            resources: [.process("Resources")],
            swiftSettings: .swiftSix
        ),
        .testTarget(
            name: "CoreDataRepositoryTests",
            dependencies: [
                "CoreDataRepository",
                .product(name: "CustomDump", package: "swift-custom-dump"),
                "Internal",
            ],
            swiftSettings: .swiftSix
        ),
        .target(
            name: "Internal",
            dependencies: [
                "CoreDataRepository",
            ],
            swiftSettings: .swiftSix
        ),
    ]
)

extension [SwiftSetting] {
    static let swiftSix: Self = [
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("DeprecateApplicationMain"),
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ImportObjcForwardDeclarations"),
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}

if ["YES", "TRUE"].contains((ProcessInfo.processInfo.environment["BENCHMARKS"])?.uppercased()) {
    package.dependencies += [
        .package(
            url: "https://github.com/ordo-one/package-benchmark.git",
            from: "1.23.5"
        ),
    ]
    
    // Benchmark of coredata-repository-benchmarks
    package.targets += [
        .executableTarget(
            name: "coredata-repository-benchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                "CoreDataRepository",
                "Internal",
            ],
            path: "Benchmarks/coredata-repository-benchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
    ]
}
