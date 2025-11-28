#!/usr/bin/env swift

//
//  generate_page.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import Foundation

// MARK: - PageType

enum PageType {
	case standard
	case form

	var pageSuffix: String {
		switch self {
		case .standard: "Page"
		case .form: "Form"
		}
	}

	var basePageProtocol: String {
		switch self {
		case .standard: "Page"
		case .form: "FormPage"
		}
	}

	var baseViewModelType: String {
		switch self {
		case .standard: "PageViewModel"
		case .form: "FormViewModel"
		}
	}

	var baseViewStateType: String {
		switch self {
		case .standard: "PageViewState"
		case .form: "FormViewState"
		}
	}

	var baseContentProtocol: String {
		switch self {
		case .standard: "PageContent"
		case .form: "FormContent"
		}
	}

	var eventHandlerType: String {
		switch self {
		case .standard: "PageEventHandler"
		case .form: "FormEventHandler"
		}
	}

	var pageImports: String {
		switch self {
		case .standard: "import PageKit"
		case .form: "import PageKit\nimport PageKitForms"
		}
	}

	var viewModelImports: String {
		switch self {
		case .standard: "import PageKit"
		case .form: "import PageKit\nimport PageKitForms"
		}
	}

	var viewStateImports: String {
		switch self {
		case .standard: "import PageKit"
		case .form: "import PageKitForms"
		}
	}

	var contentImports: String {
		switch self {
		case .standard: "import SwiftUI\nimport PageKit"
		case .form: "import SwiftUI\nimport PageKit\nimport PageKitForms"
		}
	}
}

// MARK: - Help

if CommandLine.arguments.contains("-h") || CommandLine.arguments.contains("--help") {
	print(
		"""
		Usage: swift Scripts/generate_page.swift <Name> [--form]

		Arguments:
		  <Name>    The base name for the page (e.g., Search, Login, Settings)
		  --form    Generate a form page with validation support

		Examples:
		  swift Scripts/generate_page.swift Search        → SearchPage
		  swift Scripts/generate_page.swift Login --form  → LoginForm
		  swift Scripts/generate_page.swift Settings      → SettingsPage

		Generated Files:
		  Standard: {Name}Page.swift, {Name}ViewModel.swift, {Name}ViewState.swift, {Name}Content.swift
		  Form:     {Name}Form.swift, {Name}ViewModel.swift, {Name}ViewState.swift, {Name}Content.swift
		"""
	)
	exit(0)
}

// MARK: - Parse Arguments

guard CommandLine.arguments.count > 1 else {
	print("Error: Name not provided.")
	print("Usage: swift Scripts/generate_page.swift <Name> [--form]")
	print("Use -h for more help")
	exit(1)
}

var name = CommandLine.arguments[1]

// Strip common suffixes if present
let suffixesToStrip = ["page", "form", "module"]
for suffix in suffixesToStrip {
	if name.lowercased().hasSuffix(suffix) {
		name = String(name.dropLast(suffix.count))
	}
}

// Determine page type
let isForm = CommandLine.arguments.contains("--form")
let pageType: PageType = isForm ? .form : .standard

// MARK: - Generate File Contents

let pageFileName = "\(name)\(pageType.pageSuffix)"

let pageFileContent = """
//
//  \(pageFileName).swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

\(pageType.pageImports)

final class \(pageFileName): \(pageType.basePageProtocol) {
	enum Action: CoordinatableAction {
		// Define navigation actions
	}

	let coordinator: Coordinating
	let viewState: \(name)ViewState
	let viewModel: \(name)ViewModel
	let content: \(name)Content

	init(coordinator: Coordinating) {
		self.coordinator = coordinator
		self.viewState = \(name)ViewState()
		self.viewModel = \(name)ViewModel(coordinator: coordinator, viewState: viewState)
		self.content = \(name)Content(viewState: viewState, handler: \(pageType.eventHandlerType)(viewModel))
	}
}
"""

let submitMethod = pageType == .form ? """

	override func submit() async throws {
		// Implement form submission
	}
""" : ""

let viewModelFileContent = """
//
//  \(name)ViewModel.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

\(pageType.viewModelImports)

@MainActor
final class \(name)ViewModel: \(pageType.baseViewModelType)<\(pageFileName)> {
	override func onStart() async { }

	override func handle(event: \(name)Content.Event) async { }\(submitMethod)
}
"""

let viewStateFileContent = """
//
//  \(name)ViewState.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

\(pageType.viewStateImports)

final class \(name)ViewState: \(pageType.baseViewStateType) { }
"""

let bodyContent = pageType == .form ? """
Form {
			// Add form fields here
		}
""" : """
Text("Hello from \(name)!")
"""

let contentFileContent = """
//
//  \(name)Content.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

\(pageType.contentImports)

struct \(name)Content: \(pageType.baseContentProtocol) {
	enum Event { }

	@ObservedObject var viewState: \(name)ViewState
	let handler: \(pageType.eventHandlerType)<Event>

	var body: some View {
		\(bodyContent)
	}
}
"""

let fileContents = [
	"\(pageFileName).swift": pageFileContent,
	"\(name)ViewModel.swift": viewModelFileContent,
	"\(name)ViewState.swift": viewStateFileContent,
	"\(name)Content.swift": contentFileContent
]

// MARK: - Write Files

let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath

// Determine output directory
let outputDirectory: String
if currentPath.contains("PageKit") {
	outputDirectory = "./Examples/Generated/\(name)"
} else {
	outputDirectory = "./\(name)"
}

print("Generating \(pageType == .form ? "Form" : "Page"): \(pageFileName)")
print("Output: \(outputDirectory)")
print()

for (fileName, content) in fileContents.sorted(by: { $0.key < $1.key }) {
	let filePath = "\(outputDirectory)/\(fileName)"
	do {
		try fileManager.createDirectory(
			atPath: outputDirectory,
			withIntermediateDirectories: true,
			attributes: nil
		)
		try content.write(toFile: filePath, atomically: true, encoding: .utf8)
		print("  \(fileName)")
	} catch {
		print("Error writing \(fileName): \(error)")
	}
}

print()
print("Done.")
