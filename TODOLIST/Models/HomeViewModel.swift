//
//  HomeViewModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import Foundation
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift


extension Encodable {
	func asDictionary() throws -> [String: Any] {
		let data = try JSONEncoder().encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			throw NSError()
		}
		return dictionary
	}
}

class HomeViewModel: ObservableObject {
	@Published var notes:[NoteModel] = []
	@Published var loadingNotes:Bool = true
	private let notesDataSource:String = ""
	private let db = Firestore.firestore().collection("Notes")
	// Get a reference to the storage service using the default Firebase App
	private let storageRef = Storage.storage().reference()
	
	
	@MainActor
	func getAllNotes(){
		db.order(by: "createdAt",descending: true).getDocuments { query, err in
			self.loadingNotes = false
			if let error = err {
				print("Error getting all notes \(error.localizedDescription)")
				return
			}
			guard let documents = query?.documents.compactMap({ $0 }) else {
				return
			}
			let notes = documents.map { try? $0.data(as: NoteModel.self) }
				.compactMap { $0 }
			self.notes = notes
		}
		
	}
	
	func updateNote(){
		
	}
	
	func uploadFile(file:VFiles, note:String, completionBlock: @escaping (VResult<Bool>) -> Void ) {
		let milli = Int(Date().timeIntervalSince1970)
		let path = "\(milli).jpeg"
		let imagesRef = storageRef.child(path)
		let datajpeg = UIImage(data: file.data!)?.resizeImage(newWidth: 720)!.jpegData(compressionQuality: 0.5)
		
		// Create file metadata including the content type
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"
		
		
		// Upload the file to the path "images/rivers.jpg"
		let uploadTask = imagesRef.putData(datajpeg!, metadata: metadata) { (metadata, error) in
			guard let metadata = metadata else {
				// Uh-oh, an error occurred!
				return
			}
			// Metadata contains file metadata such as size, content-type.
			let size = metadata.size
			// You can also access to download URL after upload.
			imagesRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					// Uh-oh, an error occurred!
					return
				}
				
				self.db.document(note).updateData(["file":[
					"filename": file.filename!,
					"path": path,
					"width": file.width!,
					"height": file.height!,
					"url": downloadURL.absoluteString
				]])
				completionBlock(.init(succes: true))
				self.addToList(newDoc: note)
			}
		}
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
				//print("Document data: \(dataDescription)")
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
	
	func createNewNote(title:String, description:String,urgentLevel:UrgentLevels,  deadline: Date?, file: VFiles?, completionBlock: @escaping (VResult<Bool>) -> Void ) {
		let newNote = NoteModel(userId: "meow", urgentLevel:urgentLevel, description: description, title: title , deadline: timeStampFromDeadline(deadline:deadline))
		
		var ref: DocumentReference? = nil
		ref = try! db.addDocument(from: newNote){ err in
			if let err = err {
				print("Error adding document: \(err)")
				//completionBlock(.init(fail: .init(error: err)))
			} else {
				
				print("Document added with ID: \(ref!.documentID)")
				if file != nil {
					self.uploadFile(file: file!, note: ref!.documentID,completionBlock: completionBlock)
				}else{
					completionBlock(.init(succes: true))
					self.addToList(newDoc: ref!.documentID)
				}
				
			}
		}
		
	}
	
	func deleteNote(note:NoteModel, completionBlock: @escaping (VResult<Bool>) -> Void ) {
		let auxFile = note.file
		if auxFile != nil {
			let desertRef = storageRef.child(auxFile!.path!)

			// Delete the file
			desertRef.delete { error in
				if let error = error {
					 print("Error al eliminar el archivo\(error)")
					// Uh-oh, an error occurred!
				} else {
					// File deleted successfully
				}
			}
		}
		
		db.document(note.id!).delete() { err in
				if let err = err {
					completionBlock(.init(fail: .init(error: err)))
						print("Error removing document: \(err)")
				} else {
					completionBlock(.init(succes: true))
					if let index = self.notes.firstIndex(of: note) {
						self.notes.remove(at: index)
					}
						print("Document successfully removed!")
				}
		}
	}
	
}
