//
//  NoteModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

extension UIImage {
	 
	func resizeImage(newWidth:CGFloat) -> UIImage? {
			 
			 let scale = newWidth / self.size.width
			 let newHeight = self.size.height * scale
			 UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
			 self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

			 let newImage = UIGraphicsGetImageFromCurrentImageContext()
			 UIGraphicsEndImageContext()

			 return newImage
	 }
}

enum UrgentLevels: String, Codable, CaseIterable{
	case low = "low"
	case normal = "normal"
	case high = "high"
}

struct VFiles: Codable{
	let filename:String?
	var path:String?
	var url:String?
	let width:Int?
	let height:Int?
	var data:Data?
}

struct NoteModel: Identifiable, Codable   {
	@DocumentID var id: String?
	@ServerTimestamp var createdAt: Timestamp?
	var userId: String
	var urgentLevel: UrgentLevels = .normal
	let description: String
	let title: String
	var deadline: Timestamp?
	var file:VFiles?
	
	enum CodingKeys: String, CodingKey {
		case id
		case userId
		case urgentLevel
		case description
		case title
		case createdAt
		case deadline
		case file
	}
	
	func getDateFormated(value:Timestamp) -> String {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "d MMM YYYY HH:mm:ss"
			return dateFormatter.string(from: value.dateValue())
	}
	
	func createdDate() -> String {
		return "Created at \(self.getDateFormated(value: createdAt!))"
	}
	
	func urgentColor() -> Color {
		switch self.urgentLevel{
		case .high:
			return Color.pink
		case .normal:
			return Color.VF76C6A
		case .low:
			return Color.VF79E89
		}
	}
	
	func getURLImage() -> URL {
		return URL.init(string: (file?.url)!)!
	}
	 
}
