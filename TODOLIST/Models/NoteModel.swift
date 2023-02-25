//
//  NoteModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


enum UrgentLevels: String, Codable{
	case low = "low"
	case normal = "normal"
	case high = "high"
}

struct NoteModel: Identifiable, Codable   {
	@DocumentID var id: String?
	@ServerTimestamp var createdAt: Timestamp?
	var userId: String
	var urgentLevel: UrgentLevels = .normal
	let description: String
	let title: String
	var deadline: Timestamp?
	
	enum CodingKeys: String, CodingKey {
		case id
		case userId
		case urgentLevel
		case description
		case title
		case createdAt
		case deadline
	}
	 
}
