//
//  NoteModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation

enum UrgentLevels: String{
	case low = "low"
	case normal = "normal"
	case high = "high"
}

struct NoteModel  {
	let id: String
	var urgentLevel: UrgentLevels
	let description: String
	let title: String
	let creationDate: Date?
	//let deadline: Date = Date()
	//let file: Date
	
	init(id: String, urgentLevel: UrgentLevels, description: String, title: String, creationDate: Date? ) {
		self.id = id
		self.urgentLevel = urgentLevel
		self.description = description
		self.title = title
		self.creationDate = creationDate
	}
}
