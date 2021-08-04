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
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "UUSwiftUX",
			targets: ["UUSwiftUX"]),
	],

	dependencies: [
		// Here we define our package's external dependencies
		// and from where they can be fetched:
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
