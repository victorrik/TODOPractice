//
//  VModal.swift
//  FirebasePractice
//
//  Created by Victor Andres Marcial on 11/02/23.
//

import SwiftUI
struct TestingModalView: View {
	@State var isShowing:Bool = false
		
	var body: some View {
		ZStack{
			VStack{
				Button("Touch to show",action: {
					isShowing = true
					
				})
			}
			VModal(isShowing: $isShowing){
				Text("Este es un modal")
			}
		}
	}
}

struct VModal<Content: View>: View {
	@Binding var isShowing:Bool
	@ViewBuilder var content: Content
	var body: some View {
		ZStack{
			if isShowing{
				Color.black
					.opacity(0.15)
					.ignoresSafeArea()
					.onTapGesture {
						isShowing = false
					}
				
				VStack{
					VStack(spacing:24){
						content
					}
					.padding(24)
				}
				.background(Color.white)
				.cornerRadius(8)
				.frame(maxWidth: .infinity)
				.padding(16)
				.shadow(color: .black.opacity(0.2),
								radius: 22, x: 8, y: 16)
				
				.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
		.animation(.easeInOut,value: isShowing )
		
		
		}
}

struct VModal_Previews: PreviewProvider {
		static var previews: some View {
			TestingModalView()
		}
}
