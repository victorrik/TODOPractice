//
//  TestsView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 27/02/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import UIKit
 
struct TestsView: View {
	@State private var scale = 1.0
	@State private var lastScale = 1.0
	private let minScale = 1.0
	private let maxScale = 5.0
	
	var magnification: some Gesture{
		MagnificationGesture()
//			.updating($scale) { currentState, pastState, transaction in
//				pastState = currentState
//			}
			.onChanged { state in
				adjustScale(from: state)
			}
			.onEnded { state in
				withAnimation {
					validateScaleLimits()
				}
				lastScale = 1.0
			}
	}
	 
	var body: some View {
		AsyncImage(url: URL(string:"https://firebasestorage.googleapis.com/v0/b/firevpractices.appspot.com/o/1677484767.jpeg?alt=media&token=68cac8a1-d215-4df4-8e6f-d5c08cda76ea" )) { image in
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.scaleEffect(scale)
				.gesture(magnification)
			
		} placeholder: {
			Text("meow")
		}
	}
	
	func adjustScale(from state:MagnificationGesture.Value) {
		
			let delta = state / lastScale
			scale *= delta
			lastScale = state
	}
	
	func getMinimumScaleAllowed() -> CGFloat {
		return max(scale, minScale)
	}
	
	func getMaximunScaleAllowed() -> CGFloat {
		return min(scale,maxScale)
	}
	
	func validateScaleLimits() {
		scale = getMinimumScaleAllowed()
		scale = getMaximunScaleAllowed()
	}
	
}

struct TestsView_Previews: PreviewProvider {
    static var previews: some View {
        TestsView()
    }
}
