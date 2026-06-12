// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UUSwiftUX",
	platforms: [
		.iOS(.v15),
		.macOS(.v11)
	],

	products: [
		.library(
			name: "UUSwiftUX",
			targets: ["UUSwiftUX"]),
	],

	dependencies: [
		.package(
			url: "https://github.com/SilverPineSoftware/UUSwiftCore.git",
			from: "1.5.0"
		)
	],

	targets: [
		.target(
			name: "UUSwiftUX",
			dependencies: ["UUSwiftCore"],
			path: "UUSwiftUX",
			exclude: ["Info.plist"])
	],
    swiftLanguageModes: [
		.v4_2,
		.v5,
        .v6
	]
)
