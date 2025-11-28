#!/usr/bin/env swift

//
//  generate_module.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - ModuleType

enum ModuleType {
	case form
	case standard

	var className: String {
		switch self {
			case .form:
				"Module" // FormModule is a protocol, not a class
			case .standard:
				"Module"
		}
	}

	var eventHandlerName: String {
		switch self {
			case .form:
				"FormViewEventHandler"
			case .standard:
				"ModuleViewEventHandler"
		}
	}

	var viewModelName: String {
		switch self {
			case .form:
				"FormViewModel"
			case .standard:
				"ModuleViewModel"
		}
	}

	var viewStateName: String {
		switch self {
			case .form:
				"FormViewState"
			case .standard:
				"ModuleViewState"
		}
	}

	var viewName: String {
		switch self {
			case .form:
				"FormView"
			case .standard:
				"ModuleView"
		}
	}

	var moduleProtocol: String {
		switch self {
			case .form:
				": FormModule"
			case .standard:
				": Module"
		}
	}
}

// Check for "-h" argument to print help message
if CommandLine.arguments.contains("-h") {
	print(
		"""
		Usage: swift Scripts/generate_module.swift <ModuleName> [--form]

		Arguments:
		  <ModuleName>  The name of the module to generate (e.g., Login, Signup)
		  --form        Generate a form module with validation support

		Examples:
		  swift Scripts/generate_module.swift Login
		  swift Scripts/generate_module.swift SignupForm --form
		  swift Scripts/generate_module.swift Settings
		"""
	)
	exit(0)
}

// Make sure there is a module name provided
guard CommandLine.arguments.count > 1 else {
	print("Error: Module name not provided.")
	print("Usage: swift Scripts/generate_module.swift <ModuleName> [--form]")
	print("Use -h for more help")
	exit(1)
}

var moduleName = CommandLine.arguments[1]

// Strip last "Module" from input if present
if moduleName.lowercased().hasSuffix("module") {
	moduleName = String(moduleName.dropLast("module".count))
}

// Determine module type based on flags or module name
let isFormModule = CommandLine.arguments.contains("--form") || moduleName.lowercased().hasSuffix("form")
let moduleType: ModuleType = isFormModule ? .form : .standard

// Generate validation example for form modules
let formValidationExample = moduleType == .form ? """

    override func validate() -> Bool {
        // Add your validation logic here
        // Example:
        // validateField("email", value: email, validators: [.required, .email])
        // validateField("password", value: password, validators: [.required, .minLength(6)])
        return isValid
    }
""" : ""

// Generate form submission example
let formSubmitExample = moduleType == .form ? """

    override func submit() async throws {
        // Add your form submission logic here
        // Example:
        // try await apiService.submit(data: formViewState)
        // coordinator.send(action: .submitSuccess)
    }
""" : ""

let moduleFileContent = """
//
//  \(moduleName)Module.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

final class \(moduleName)Module\(moduleType.moduleProtocol) {
    enum Action: CoordinatableAction {
        // Define actions that can be sent to the coordinator
        // Example: case didComplete, case showDetail(String)
    }

    enum Signal: ModuleSignal {
        // Define signals that can be published (optional)
        // Example: case dataUpdated, case errorOccurred(Error)
    }

    let coordinator: Coordinating
    let viewState: \(moduleName)ViewState

    // Additional dependencies (add as needed)
    // Example: let apiService: APIService

    lazy var viewModel: \(moduleName)ViewModel = .init(
        coordinator: self.coordinator,
        viewState: self.viewState
        // Pass additional dependencies here
        // apiService: self.apiService
    )

    lazy var view: \(moduleName)View = .init(
        viewState: self.viewState,
        handler: \(moduleType.eventHandlerName)(viewModel)
    )

    init(coordinator: Coordinating /* add dependencies here if needed */) {
        self.coordinator = coordinator
        self.viewState = .init()

        // Store additional dependencies
        // self.apiService = apiService
    }
}
"""

let viewModelFileContent = """
//
//  \(moduleName)ViewModel.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

@MainActor
class \(moduleName)ViewModel: \(moduleType.viewModelName)<\(moduleName)Module> {
    // CRITICAL: Use weak reference to avoid retain cycle
    // The coordinator reference is inherited from the base class

    // Add properties here
    // Example: let apiService: APIService

    nonisolated init(
        coordinator: Coordinating,
        viewState: \(moduleName)ViewState
        // Add dependencies here if needed
        // apiService: APIService
    ) {
        // Store dependencies before calling super.init
        // self.apiService = apiService

        super.init(coordinator: coordinator, viewState: viewState)
    }

    override func onStart() async {
        // Async startup logic goes here
        // No need for Task { @MainActor in } - we're already on MainActor
        // Example:
        // await loadInitialData()
    }

    override func onResume() async {
        // Async resume logic goes here
        // Example:
        // await refreshData()
    }

    override func handle(event _: \(moduleName)View.Event) {
        // View event handling logic goes here
        // This method is already on MainActor
        // Example:
        // switch event {
        // case .buttonTapped:
        //     coordinator.send(action: .showNext)
        // }
    }\(formSubmitExample)

    // Private helper methods
    // private func loadInitialData() async {
    //     // API calls automatically run on background thread
    //     // Results automatically return to MainActor
    // }
}
"""

let viewStateFileContent = """
//
//  \(moduleName)ViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

class \(moduleName)ViewState: \(moduleType.viewStateName) {
    // Add @Published properties here
    // Example:
    // @Published var title: String = ""
    // @Published var isLoading: Bool = false\(formValidationExample)
}
"""

let formViewExample = """
Form {
            FormSection("Section Title") {
                // Add form fields here
                // Example:
                // FormField("Email", text: $viewState.email, validators: [.required, .email])
                // FormField("Password", text: $viewState.password, isSecure: true, validators: [.required, .minLength(6)])
            }

            FormSection {
                FormSubmitButton("Submit") {
                    await viewModel.handleSubmit()
                }
                .environmentObject(viewState)
            }

            FormErrorView()
                .environmentObject(viewState)
        }
        .navigationTitle("\(moduleName)")
"""

let standardViewExample = """
VStack {
            // Add your view content here
            Text("Hello from \(moduleName)!")
        }
        .navigationTitle("\(moduleName)")
"""

let viewFileContent = """
//
//  \(moduleName)View.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

struct \(moduleName)View: \(moduleType.viewName) {
    enum Event {
        // Define view events here if needed
        // Example: case buttonTapped, case itemSelected(String)
    }

    @StateObject
    var viewState: \(moduleName)ViewState

    var handler: \(moduleType.eventHandlerName)<Event>

    // Additional properties go here

    var body: some View {
        // Build your view here
        \(moduleType == .form ? formViewExample : standardViewExample)
    }
}

// MARK: - Preview

#if DEBUG
struct \(moduleName)View_Previews: PreviewProvider {
    static var previews: some View {
        \(moduleName)View(
            viewState: \(moduleName)ViewState(),
            handler: \(moduleType.eventHandlerName) { _ in }
        )
    }
}
#endif
"""

let fileContents = [
	"\(moduleName)Module.swift": moduleFileContent,
	"\(moduleName)ViewModel.swift": viewModelFileContent,
	"\(moduleName)ViewState.swift": viewStateFileContent,
	"\(moduleName)View.swift": viewFileContent
]

let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath

// Determine output directory
let outputDirectory: String
if currentPath.contains("ModuleFramework") {
	// Running from within ModuleFramework package
	outputDirectory = "./Examples/Generated/\(moduleName)"
} else {
	// Running from a consumer project
	outputDirectory = "./\(moduleName)"
}

print("📦 Generating \(moduleType == .form ? "Form" : "Standard") Module: \(moduleName)")
print("📁 Output directory: \(outputDirectory)")
print()

for (fileName, content) in fileContents {
	let filePath = "\(outputDirectory)/\(fileName)"
	do {
		try fileManager.createDirectory(
			atPath: outputDirectory,
			withIntermediateDirectories: true,
			attributes: nil
		)
		try content.write(toFile: filePath, atomically: true, encoding: .utf8)
		print("✅ Generated: \(fileName)")
	} catch {
		print("❌ Error writing \(fileName): \(error)")
	}
}

print()
print("🎉 Module generation complete!")
print()
print("Next steps:")
print("1. Add the generated files to your Xcode project")
print("2. Update the module with your business logic")
if moduleType == .form {
	print("3. Add validation rules in \(moduleName)ViewState.validate()")
	print("4. Implement form submission in \(moduleName)ViewModel.submit()")
} else {
	print("3. Implement your view in \(moduleName)View.body")
	print("4. Add event handling in \(moduleName)ViewModel.handle(event:)")
}
print("5. Navigate to the module from your coordinator")
print()
