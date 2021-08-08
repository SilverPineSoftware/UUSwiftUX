// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UUSwiftUX",
	platforms: [
		.iOS(.v10),
		.macOS(.v10_15)
	],

	products: [
		.library(
			name: "UUSwiftUX",
			targets: ["UUSwiftUX"]),
	],

	dependencies: [
		.package(
			url: "https://github.com/SilverPineSoftware/UUSwiftCore.git",
			from: "1.0.2"
		)
	],

	targets: [
		.target(
			name: "UUSwiftUX",
			dependencies: ["UUSwiftCore"],
			path: "UUSwiftUX",
			exclude: ["Info.plist"])
	],
	swiftLanguageVersions: [
		.v4_2,
		.v5
	]
)
