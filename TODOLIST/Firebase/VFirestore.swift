//
//  VFirestore.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import Foundation
import FirebaseFirestore


struct FirestoreError {
	var message:String
	var code:String
}

struct FirestoreResult<InfoResult>{
	var succes: Bool
	var info: InfoResult?
	var failure:FirestoreError
	
	init(succes: Bool = false,info: InfoResult? = nil, failure: FirestoreError = FirestoreError(message: "", code: "")) {
		self.succes = succes
		self.info = info
		self.failure = failure
	}
}

struct VFirestore {
	static private func toMillis(date:Timestamp)-> Int64 {
		
		let losNaNo = Double(date.nanoseconds) / 1e6;
		return date.seconds * 1000 + Int64(losNaNo)
	}
	 
	static private func makeCollection(query: DocumentReference,path: inout[String])->Any{
		if path.isEmpty{ return query }
		
		let temp = query.collection(path[0])
		path.removeFirst()
		return makeDoc(query: temp , path: &path)
	}
	
	static private func makeDoc(query:CollectionReference,path: inout [String])->Any{
		if path.isEmpty{ return query }
		let temp = query.document(path[0])
		path.removeFirst()
		return makeCollection(query: temp , path: &path)
	}
	
	static private func createRef(_ firebasePath: [String])-> Any{
		var auxPath = firebasePath;
		
		let query = Firestore.firestore().collection(auxPath[0])
		
		auxPath.removeFirst()
		return makeDoc(query: query,  path: &auxPath)
	};
	static func createDoc(path firebasePath:[String], data:[String:Any]) async -> FirestoreResult<String> {
		
		var rtResult = FirestoreResult<String>()
		let docRef = self.createRef(firebasePath) as! CollectionReference
	 
		do{
			let meow = try await docRef.addDocument(data: data)
		 
			rtResult.succes = true
				 
			print("meow\(meow)")
			print("meow------>\(meow.documentID)")
			rtResult.info = meow.documentID
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
	static func getDoc(path firebasePath:[String]) async -> FirestoreResult<[String:Any]> {
		
		var rtResult = FirestoreResult<[String:Any]>()
		let docRef = self.createRef(firebasePath) as! DocumentReference
	 
		do{
			let docResult = try await docRef.getDocument()
			if docResult.exists {
				rtResult.succes = true
				var dataDescription = docResult.data()!
				dataDescription["id"] = docResult.documentID
//
//				if dataDescription["creationDate"] != nil, let newCreationDate = dataDescription["creationDate"] as? Timestamp{
//					print(newCreationDate)
//					dataDescription["creationDate"] =  newCreationDate.dateValue()
//				}
				
				rtResult.info = dataDescription
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
			}
			rtResult.failure.code = "DocumentNotExist"
			rtResult.failure.message = "No existe el doc waku waku"
			return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
	
	static func setDoc(path firebasePath:[String]) async -> FirestoreResult<Dictionary<String,Any>> {
		
		var rtResult = FirestoreResult<Dictionary<String,Any>>()
		let docRef = self.createRef(firebasePath) as! DocumentReference
	 
		do{
			let docResult = try await docRef.getDocument()
			if docResult.exists {
				rtResult.succes = true
				var dataDescription = docResult.data()!
				dataDescription["id"] = docResult.documentID
				rtResult.info = dataDescription
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
			}
			rtResult.failure.code = "DocumentNotExist"
			rtResult.failure.message = "No existe el doc waku waku"
			return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
	static func updatetDoc(path firebasePath:[String]) async -> FirestoreResult<Dictionary<String,Any>> {
		
		var rtResult = FirestoreResult<Dictionary<String,Any>>()
		let docRef = self.createRef(firebasePath) as! DocumentReference
	 
		do{
			let docResult = try await docRef.getDocument()
			if docResult.exists {
				rtResult.succes = true
				var dataDescription = docResult.data()!
				dataDescription["id"] = docResult.documentID
				rtResult.info = dataDescription
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
			}
			rtResult.failure.code = "DocumentNotExist"
			rtResult.failure.message = "No existe el doc waku waku"
			return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
	
	static func deleteDoc(path firebasePath:[String]) async -> FirestoreResult<Dictionary<String,Any>> {
		
		var rtResult = FirestoreResult<Dictionary<String,Any>>()
		let docRef = self.createRef(firebasePath) as! DocumentReference
	 
		do{
			let docResult = try await docRef.getDocument()
			if docResult.exists {
				rtResult.succes = true
				var dataDescription = docResult.data()!
				dataDescription["id"] = docResult.documentID
				rtResult.info = dataDescription
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
			}
			rtResult.failure.code = "DocumentNotExist"
			rtResult.failure.message = "No existe el doc waku waku"
			return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
	
	
	static func getDocCollection(path firebasePath:[String]) async -> FirestoreResult<Dictionary<String,Any>> {
		
		var rtResult = FirestoreResult<Dictionary<String,Any>>()
		let docRef = self.createRef(firebasePath) as! DocumentReference
	 
		do{
			let docResult = try await docRef.getDocument()
			if docResult.exists {
				rtResult.succes = true
				var dataDescription = docResult.data()!
				dataDescription["id"] = docResult.documentID
				rtResult.info = dataDescription
				//let dataDescription = try! await JSONDecoder().decode(TextAppModel.self, from: docResult.data())
				return rtResult
			}
			rtResult.failure.code = "DocumentNotExist"
			rtResult.failure.message = "No existe el doc waku waku"
			return rtResult
		}
		catch{
			print("There was an issue when trying to sign in: \(error)")
			//docResult.failure(error)
			rtResult.failure.code = "Meow meow un error"
			rtResult.failure.message = error.localizedDescription
			return rtResult
		}
	}
}
