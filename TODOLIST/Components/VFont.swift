//
//  VFont.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

enum FontType {
	case h1, h2, h3, h4, b1, b2, small, button
}

struct VFont: View {
	let content:String
	let type: FontType
	var size: CGFloat = 16
	
	init(_ content: String, type: FontType = .b1) {
		self.content = content
		self.type = type
	}
	
	func getFontFamily(_ typeFont:FontType) -> String {
		switch(typeFont){
		case .h1, .h2, .h3, .h4 :
			return "Bebas neue"
		default:
			return "Monserrat"
		}
	}
	
	func getFontSize(_ typeFont:FontType) ->  CGFloat{
		switch(typeFont){
		case .h1 :
			return 73
		case .h2 :
			return 45
		case .h3:
			return 36
		case .h4 :
			return 26
		case .b1 :
			return 16
		case .b2, .button :
			return 14
		case .small :
			return 12
		}
	}
	
	func getFontTracking(_ typeFont:FontType) ->  CGFloat{
		switch(typeFont){
		case .h1 :
			return -3.5
		case .h2 :
			return -1
		case .h4, .b1, .b2 :
			return 1
		case .button :
			return 5
		default:
			return 0
		}
	}
	var body: some View {
		Text(content)
			.font(.custom(getFontFamily(type), size: getFontSize(type)))
			.tracking(getFontTracking(type))
	}
}

struct VFont_Previews: PreviewProvider {
    static var previews: some View {
			ScrollView{
				VStack{
					VFont("Headline 1",type: .h1)
					VFont("Headline 2",type: .h2)
					VFont("Headline 3",type: .h3)
					VFont("Headline 4",type: .h4)
					VFont("Body 1",type: .b1)
					VFont("Body 2",type: .b2)
					VFont("Small",type: .small)
					VFont("Button",type: .button)
				}
			}
    }
}
