//
//  VIcons.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

enum IconsAvailable:String {
	case arrowLeft = "arrow.left"
	case boxArrowUpRight = "square.and.arrow.up"
	case calendar = "calendar"
	case check = "checkmark"
	case chevronRight = "chevron.right"
	case clipboard = "clipboard"
	case dash = "minus"
	case envelope = "envelope"
	case eye = "eye"
	case eyeSlash = "eye.slash"
	case graphUpArrow = "chart.line.uptrend.xyaxis"
	case infoCircle = "info.circle"
	case link45deg = "link"
	case lock = "lock"
	case pencilSquare = "square.and.pencil"
	case pencil = "pencil"
	case person = "person"
	case personPlus = "person.badge.plus"
	case share = "square.and.arrow.up.circle"
	case x = "xmark"
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
				VIcons()
		}
}

