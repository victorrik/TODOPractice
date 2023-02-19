//
//  HomeViewModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation

class HomeViewModel: ObservableObject {
	@Published var notes:[NoteModel] = []
	
	func saveNote(newNote:NoteModel)  {
		notes.insert(newNote, at: 0)
	}
	
}
