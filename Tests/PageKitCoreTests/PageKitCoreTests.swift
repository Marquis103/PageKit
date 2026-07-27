//
//  PageKitCoreTests.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

import Foundation
import Testing
@testable import PageKitCore

// MARK: - Fixtures

private struct TestSignal: PageSignal {
	let value: Int
}

private enum TestAction: CoordinatableAction {
	case something
}

/// The minimal portable coordinator — exactly what the PE-533 split promises
/// a feature module can write against PageKitCore alone.
@MainActor
private final class BusBackedCoordinator: Coordinating {
	private let bus = PageSignalBus()
	private(set) var received: [any CoordinatableAction] = []

	func coordinate(action: CoordinatableAction) {
		received.append(action)
	}

	func send(signal: PageSignal) {
		bus.send(signal)
	}

	func signals() -> AsyncStream<PageSignal> {
		bus.stream()
	}
}

// MARK: - Signal multicast

@Suite("PageSignalBus multicast")
@MainActor
struct PageSignalBusTests {

	@Test("Two subscribers each receive every signal — the classic silent multicast failure")
	func twoSubscribersBothReceive() async {
		let bus = PageSignalBus()

		let first = bus.stream()
		let second = bus.stream()

		async let firstValues: [Int] = {
			var values: [Int] = []
			for await signal in first {
				if let signal = signal as? TestSignal { values.append(signal.value) }
				if values.count == 2 { break }
			}
			return values
		}()
		async let secondValues: [Int] = {
			var values: [Int] = []
			for await signal in second {
				if let signal = signal as? TestSignal { values.append(signal.value) }
				if values.count == 2 { break }
			}
			return values
		}()

		// Let both subscription tasks attach before sending.
		await Task.yield()
		await Task.yield()

		bus.send(TestSignal(value: 1))
		bus.send(TestSignal(value: 2))

		let (a, b) = await (firstValues, secondValues)
		#expect(a == [1, 2])
		#expect(b == [1, 2])
	}

	@Test("finish() ends every subscriber's stream")
	func finishEndsStreams() async {
		let bus = PageSignalBus()
		let stream = bus.stream()

		async let drained: Bool = {
			for await _ in stream {}
			return true
		}()

		await Task.yield()
		bus.finish()

		#expect(await drained)
	}

	@Test("A non-publishing Coordinating conformer vends a finished stream by default")
	func defaultSignalsFinishImmediately() async {
		@MainActor final class Silent: Coordinating {
			func coordinate(action _: CoordinatableAction) {}
		}

		var count = 0
		for await _ in Silent().signals() {
			count += 1
		}
		#expect(count == 0)
	}
}

// MARK: - Coordinating surface

@Suite("Coordinating portable surface")
@MainActor
struct CoordinatingSurfaceTests {

	@Test("coordinate(action:) round-trips through the portable protocol")
	func coordinateRoundTrip() {
		let coordinator = BusBackedCoordinator()

		coordinator.coordinate(action: TestAction.something)

		#expect(coordinator.received.count == 1)
		#expect(coordinator.received.first is TestAction)
	}

	@Test("A bus-backed coordinator multicasts through the protocol surface")
	func protocolSurfaceMulticasts() async {
		let coordinator = BusBackedCoordinator()
		let stream = coordinator.signals()

		async let value: Int? = {
			for await signal in stream {
				if let signal = signal as? TestSignal { return signal.value }
			}
			return nil
		}()

		await Task.yield()
		coordinator.send(signal: TestSignal(value: 7))

		#expect(await value == 7)
	}
}

// MARK: - Purity gate

@Suite("PageKitCore purity")
struct PageKitCorePurityTests {

	/// The split's whole point, enforced: no UIKit, no Combine anywhere in
	/// the portable core's sources. Walks the target directory via #filePath.
	@Test("Core sources contain no UIKit or Combine imports")
	func noUIKitOrCombineImports() throws {
		let testsDir = URL(fileURLWithPath: #filePath)
			.deletingLastPathComponent()   // PageKitCoreTests/
			.deletingLastPathComponent()   // Tests/
		let coreDir = testsDir
			.deletingLastPathComponent()   // package root
			.appendingPathComponent("Sources/PageKitCore")

		let files = FileManager.default
			.enumerator(at: coreDir, includingPropertiesForKeys: nil)?
			.compactMap { $0 as? URL }
			.filter { $0.pathExtension == "swift" } ?? []

		#expect(!files.isEmpty, "Purity gate found no sources — path drift?")

		for file in files {
			let source = try String(contentsOf: file, encoding: .utf8)
			let offending = source
				.components(separatedBy: .newlines)
				.first { line in
					let trimmed = line.trimmingCharacters(in: .whitespaces)
					return trimmed == "import UIKit" || trimmed == "import Combine"
				}
			#expect(offending == nil, "\(file.lastPathComponent) imports UIKit/Combine")
		}
	}
}
