//
//  HomeViewModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class HomeViewModel: ObservableObject {
	@Published var notes:[NoteModel] = []
	private let notesDataSource:String = ""
	private let db = Firestore.firestore().collection("Notes")
	
	@MainActor
	func getAllNotes()async{
		do{
			let resultNotes = try await db.order(by: "createdAt",descending: true) .getDocuments()
			print("-->\(resultNotes)")
			let notes = resultNotes.documents.map{ try? $0.data(as: NoteModel.self) }.compactMap { $0 }
			self.notes = notes
		}catch{
			print("errror->\(error)")
		}
	}
	
	func updateNote(){
		
	}
	
	private func timeStampFromDeadline(deadline:Date?) -> Timestamp? {
		guard let date = deadline else { return nil }
		return Timestamp(date: Calendar.current.startOfDay(for: date))
	}
	
	private func addToList(newDoc:String){
		db.document(newDoc).getDocument { document, error in
			if let document = document, document.exists {
				//let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
				let dataDescription = try! document.data(as: NoteModel.self)
				print("Document data: \(dataDescription)")
				self.notes.insert(dataDescription, at: 0)

			} else {
				print("Document does not exist")
			}
		}
		//		do{
		//			let newDocResult = try
		//			print("---newDocResult->\(newDocResult.data())")
		//			let noteCreate = try newDocResult.data(as: NoteModel.self)
		//			print("---noteCreate->\(noteCreate.createdAt)")
		//			//notes.insert(noteCreate, at: 0)
		//		}catch{
		//			print("Errro->\(error)")
		//		}
	}
	func createNewNote(title:String, description:String, deadline: Date?, completionBlock: @escaping (VResult<Bool>) -> Void ) {
		let newNote = NoteModel(userId: "meow", description: description, title: title, deadline: timeStampFromDeadline(deadline:deadline) )
		
		var ref: DocumentReference? = nil
		ref = try! db.addDocument(from: newNote){ err in
			if let err = err {
				print("Error adding document: \(err)")
				//completionBlock(.init(fail: .init(error: err)))
			} else {
				print("Document added with ID: \(ref!.documentID)")
				completionBlock(.init(succes: true))
				self.addToList(newDoc: ref!.documentID)
			}
		}
		
	}
	
	func deleteNote() {
		
	}
	
}
