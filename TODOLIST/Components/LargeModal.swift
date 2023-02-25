//
//  LargeModal.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 19/02/23.
//

import SwiftUI

struct TestingLargeModalView: View {
	@State var isShowing:Bool = false
		
	var body: some View {
		ZStack{
			VStack{
				Button("Touch to show",action: {
					isShowing = true
					
				})
			}
			LargeModal(isShowing: $isShowing){
				Text("Este es un modal")
			}
		}
	}
}
struct LargeModal<Content: View>: View {
	
	@Binding var isShowing:Bool
	@State private var curHeight: CGFloat = 500
	@State private var prevDragTranslation = CGSize.zero
	@State private var isDragging = false
	@State private var minHeight: CGFloat = 500
	@State private var maxHeight: CGFloat = 700
	@State private var paddingBottom: CGFloat = 10
	@ViewBuilder var content: Content
	
	func setMaxMinSize(proxy:GeometryProxy) {
		let lessTop = proxy.safeAreaInsets.top + 20
		maxHeight = proxy.size.height - lessTop
		minHeight = proxy.size.height - lessTop
		paddingBottom = proxy.safeAreaInsets.bottom
		withAnimation(.linear){
			curHeight = proxy.size.height - lessTop
		}
	}
	var body: some View {
		
		GeometryReader{ proxy in
			ZStack(alignment:.bottom){
				if isShowing{
					Color.black
						.opacity(0.15)
						.ignoresSafeArea()
					
					mainView
						.transition(.move(edge: .bottom).combined(with: .opacity))
				}
			}
			.onAppear{
				setMaxMinSize(proxy:proxy)
			}
			.ignoresSafeArea()
			.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
			
			.animation(.easeInOut,value: isShowing )
		}
		
	}
	var mainView: some View {
		
		VStack{
			ZStack{
				Capsule()
					.frame(width:80,height: 6)
					.foregroundColor(.white)
			}
			.frame(height: 40)
			.frame(maxWidth: .infinity)
			.background(Color.white.opacity(0.00001)) //this is importan for dragging
			.gesture(dragGesture)
			
			ZStack{
				VStack(spacing: 16){
					content
				}
				.padding(.horizontal)
				.padding(.bottom,paddingBottom + 20)
				
			}
			.frame(maxHeight: .infinity)
			
		}
		.frame(height: curHeight)
		.frame(maxWidth: .infinity)
		.background(
			RoundedCornersShape(corners: [.topLeft, .topRight], radius: 30)
				.fill(Color.VF79E89)
		)
		.animation(.easeInOut(duration: 0.32), value: !isDragging)
	}
	
	var dragGesture: some Gesture{
		DragGesture(minimumDistance: 0, coordinateSpace: .global)
			.onChanged { value in
				if !isDragging{
					isDragging = true
				}
				let dragAmount = value.translation.height - prevDragTranslation.height
				if curHeight > maxHeight || curHeight < (minHeight - 100){
					curHeight -= dragAmount / 6
				}else{
					curHeight -= dragAmount
				}
				prevDragTranslation = value.translation
			}
			.onEnded {  value in
				isDragging = false
				if curHeight > maxHeight{
					curHeight = maxHeight
				}else if curHeight < minHeight{
					curHeight = minHeight
					
				}
				if prevDragTranslation.height > 70{
					isShowing = false
				}
				prevDragTranslation = .zero
			}
	}
}

struct LargeModal_Previews: PreviewProvider {
    static var previews: some View {
			TestingLargeModalView()
    }
}
