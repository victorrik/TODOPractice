//
//  VShrimmer.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 03/03/23.
//

import SwiftUI

struct AnimatedMask: AnimatableModifier {
	var phase: CGFloat = 0
	let centerColor:Color
	let edgeColor: Color
	
	var animatableData: CGFloat {
		get { phase }
		set { phase = newValue }
	}
	
	func body(content: Content) -> some View {
		content
			.background{
				LinearGradient(gradient:
												Gradient(stops: [
													.init(color: edgeColor, location: phase + 0),
													.init(color: centerColor, location: phase + 0.1),
													.init(color: edgeColor, location: phase + 0.2),
												]),
											 startPoint: .topLeading,
											 endPoint: .bottomTrailing)
			}
	}
}
struct VShrimmer: View {
	@State private var phase: CGFloat = -1
	
	let animation: Animation
	let centerColor:Color
	let edgeColor: Color
	
	
	///https://github.com/markiv/SwiftUI-Shimmer
	/// Convenience, backward-compatible initializer.
	/// - Parameters:
	///   - duration: The duration of a shimmer cycle in seconds. Default: `1.5`.
	///   - bounce: Whether to bounce (reverse) the animation back and forth. Defaults to `false`.
	///   - delay:A delay in seconds. Defaults to `0`.
	init(duration: Double = 1.5,
			 bounce: Bool = false,
			 delay: Double = 0,
			 centerColor:Color = .black,
			 edgeColor: Color = .black.opacity(0.3)) {
		self.animation = .linear(duration: duration)
			.repeatForever(autoreverses: bounce)
			.delay(delay)
		
		self.centerColor = centerColor
		self.edgeColor = edgeColor
	}
	
	var body: some View {
		Rectangle()
			.foregroundColor(.white.opacity(0))
			.modifier(AnimatedMask(phase:self.phase , centerColor: self.centerColor, edgeColor: self.edgeColor))
			.animation(animation, value: phase)
			.scaleEffect(1)
			.onAppear{
				phase = 1
			}
	}
}

struct VShrimmer_Previews: PreviewProvider {
    static var previews: some View {
        VShrimmer()
    }
}
