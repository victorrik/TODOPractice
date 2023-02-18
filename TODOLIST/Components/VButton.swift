//
//  VButton.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI
 
struct TestingButtonView: View {
	
	@ObservedObject var buttonRef:VButtonRef = VButtonRef()
	func makeLikeIDo() {
		buttonRef.handleLoading(true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			buttonRef.handleLoading(false)
		}
	}
	var body: some View {
		VStack{
			 
			VButton("Button normal") {
				print("Waku Waku")
			}
			VButton("Button with load", action: {
				makeLikeIDo()
			}, ref:buttonRef)
			VButton("Button with load",type: .secondary, action: {
				makeLikeIDo()
			},  ref:buttonRef)
			Text("Im loading ->\(buttonRef.isLoading ? "yes":"Not")")
		}
	}
}

enum ButtonType {
	case primary, secondary, tertiary
}

final class VButtonRef: ObservableObject {
	@Published var isLoading: Bool = false
	
	func handleLoading(_ bool:Bool) {
		self.isLoading = bool
	}
}

struct VButton: View {
	let type: ButtonType
	var title: String
	let action: ()-> Void
	var icon: IconsAvailable?
	var disabled: Bool = false
	var iconLeft: Bool = false
	@ObservedObject var buttonRef: VButtonRef = VButtonRef()
	
	init(_ title: String,
			 type: ButtonType = .primary,
			 action:@escaping ()-> Void,
			 icon: IconsAvailable? = nil,
			 disabled: Bool = false,
			 iconLeft: Bool = false,
			 ref: VButtonRef = VButtonRef()
 ) {
		self.type = type
		self.title = title
		self.action = action
		self.icon = icon
		self.disabled = disabled
		self.iconLeft = iconLeft
		self.buttonRef = ref
	}
    var body: some View {
			ZStack{
				 Button(action: action, label: {
					 VFont(title,type: .button)
						 .frame(height: 48)
							.frame(maxWidth: .infinity)
							.foregroundColor(type == .primary ? .white : Color.VF79E89)
							.background(type == .primary ? Color.VF79E89 : .white)
							.cornerRadius(12)
				 })
				 .buttonStyle(.plain)
				if buttonRef.isLoading {
					
					VStack{
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: type == .primary ? .white : Color.VF79E89))
					}
					.frame(height: 48)
					.frame(maxWidth: .infinity)
					.background(type == .primary ? Color.VF79E89 : .white)
					.cornerRadius(12)
					
				}
				
			 }
    }
}

struct VButton_Previews: PreviewProvider {
    static var previews: some View {
			TestingButtonView()
    }
}
