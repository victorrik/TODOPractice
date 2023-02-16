//
//  VButton.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct VButtonModifier: ViewModifier {
	func body(content:Content) -> some View {
		content
			.frame(height: 48)
			.frame(maxWidth: .infinity)
			.foregroundColor(.white)
			.background(Color.VF79E89)
			.buttonStyle(.plain)
			.cornerRadius(12)
			
	}
}

extension Button {
	func vButton() -> some View {
		self.modifier(VButtonModifier())
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
	var icon: String?
	var disabled: Bool = false
	var iconLeft: Bool = false
	@ObservedObject var butonRef: VButtonRef = VButtonRef()
	init(_ title: String,
			 type: ButtonType = .primary,
			 action:@escaping ()-> Void,
			 icon: String? = nil,
			 disabled: Bool = false,
			 iconLeft: Bool = false,
			 butonRef: VButtonRef = VButtonRef()
 ) {
		self.type = type
		self.title = title
		self.action = action
		self.icon = icon
		self.disabled = disabled
		self.iconLeft = iconLeft
		self.butonRef = butonRef
	}
    var body: some View {
			ZStack{
				 Button(action: action, label: {
					 VFont(title,type: .button)
				 })
				 .vButton()
			 
				if butonRef.isLoading {
					
					HStack{
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .white))
					}
					.frame(height: 48)
					.frame(maxWidth: .infinity)
					.background(Color.VF79E89)
					
				}
				
			 }
    }
}

struct VButton_Previews: PreviewProvider {
    static var previews: some View {
        VButton("Botton",action: {
					print("meow")
				})
    }
}
