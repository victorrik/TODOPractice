//
//  VIcons.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

enum IconsAvailable:String {
	case plus = "plus"
	case plusSquare = "plus.square"
	case plusCircle = "plus.circle"
	case lineHorizontal = "line.3.horizontal"
	case book = "book"
	case calendar = "calendar"
	case rectangleArrowRight = "rectangle.portrait.and.arrow.right"
	case trash = "trash"
	case chevronLeft = "chevron.left"
	case chevronRight = "chevron.right"
	case bubbleLeft = "bubble.left"
	case gearshape = "gearshape"
	case checkmarkSquare = "checkmark.square"
	case star = "star"
	case lineDecreaseCircle = "line.3.horizontal.decrease.circle"
	case pencil = "pencil"
	case photo = "photo"
	case magnifyingglass = "magnifyingglass"
	case clock = "clock"
	case lock = "lock"
	case person = "person"
	case envelope = "envelope"
	case eye = "eye"
	case eyeSlash = "eye.slash"
	 
}
struct VIcons: View {
	let name: IconsAvailable
	let color: Color
	let size: CGFloat
	
	init(name: IconsAvailable = .person, color: Color = .black, size: CGFloat = 14) {
		self.name = name
		self.color = color
		self.size = size
	}
	
	var body: some View {
		
		Image(systemName: name.rawValue)
			.resizable()
			.foregroundColor(color)
			.aspectRatio(contentMode: .fit)
			.frame(width: size,height: size)
	}
}

struct VIcons_Previews: PreviewProvider {
		static var previews: some View {
			VStack(spacing:20){
				HStack(spacing:20){
					VIcons(name:.plus, size: 40)
					VIcons(name:.plusSquare, size: 40)
					VIcons(name:.plusCircle, size: 40)
					VIcons(name:.lineHorizontal, size: 40)
					VIcons(name:.book, size: 40)
				}
				HStack(spacing:20){
					VIcons(name:.calendar, size: 40)
					VIcons(name:.rectangleArrowRight, size: 40)
					VIcons(name:.trash, size: 40)
					VIcons(name:.chevronLeft, size: 40)
					VIcons(name:.chevronRight, size: 40)
				}
				HStack(spacing:20){
					VIcons(name:.bubbleLeft, size: 40)
					VIcons(name:.gearshape, size: 40)
					VIcons(name:.checkmarkSquare, size: 40)
					VIcons(name:.star, size: 40)
					VIcons(name:.lineDecreaseCircle, size: 40)
				}
				HStack(spacing:20){
					VIcons(name:.pencil, size: 40)
					VIcons(name:.photo, size: 40)
					VIcons(name:.magnifyingglass, size: 40)
					VIcons(name:.clock, size: 40)
					VIcons(name:.lock, size: 40)
				}
				HStack(spacing:20){
					VIcons(name:.person, size: 40)
					VIcons(name:.envelope, size: 40)
					VIcons(name:.eye, size: 40)
					VIcons(name:.eyeSlash, size: 40)
				}
			}
		}
}

