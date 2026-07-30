// PE-536/E4 spike/android: SkipSwiftUI API-gap shims, scoped to this spike.
#if os(Android)
import SwiftUI

extension View {
	/// SkipSwiftUI has no contentShape; hit-testing shape is a no-op on Android.
	public func contentShape<S: Shape>(_ shape: S) -> some View {
		self
	}
}
#endif
