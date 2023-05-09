// swift-tools-version:5.3
//
import PackageDescription

let package = Package(
    name: "WalletKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "WalletKit",
            targets: ["WalletKit"]
        ),
    ],

    dependencies: [
        .package(name: "WalletKitCore", url: "https://github.com/rockwalletcode/wallet-kit-core.git", .revision("9ea1735a3657cb734f0f4e1fc1fc2479a3af0494"))
    ],

    targets: [
        .target(
            name: "WalletKit",
            dependencies: [
                .product(name: "WalletKitCore", package: "WalletKitCore"),
            ],
            path: "WalletKit"
        ),
    ]
)
