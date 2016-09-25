import PackageDescription

let package = Package(
    name: "KemoAll",    
    targets: [
        Target(name: "KemoCore", dependencies: ["KemoLogger"]),
        Target(name: "KemoApp", dependencies: ["KemoCore"])
    ],
    dependencies: [
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git",  "0.6.0"),
        .Package(url: "https://github.com/daltoniam/Starscream.git", "2.0.0")
    ]
)