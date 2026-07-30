// PE-536/E4 spike/android: SkipSwiftUI API-gap shims, scoped to this spike.
import SwiftUI

extension View {
	/// `.contentShape(Rectangle())` — SkipSwiftUI lacks contentShape, and the
	/// hit-testing default is acceptable there; Darwin keeps the real call.
	public func pkContentShape() -> some View {
		#if os(Android)
		self
		#else
		contentShape(Rectangle())
		#endif
	}
}
