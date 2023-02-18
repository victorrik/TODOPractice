//
//  VAuth.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import Foundation
import FirebaseAuth

struct AuthError {
	var message:String
	var description:String
	var code: AuthErrorCode.Code
	
	init(error:Error) {
		let description = error.localizedDescription
		let handleError = error as NSError
		var message = ""
		
		switch AuthErrorCode.Code(rawValue: handleError.code){
			case .invalidEmail:
				message = "Corrreo no valido"
			case .wrongPassword:
				message = "Contraseña incorrecta"
			default:
				message = "Sos pelotudo"
		}
		
		self.message = message
		self.description = description
		self.code = AuthErrorCode.Code(rawValue: handleError.code)!
	}
}

struct AuthResult<InfoResult>{
	var succes: Bool
	var info: InfoResult?
	var failure:AuthError?
	
	init(succes: Bool = false,info: InfoResult? = nil, failure: AuthError? = nil) {
		self.succes = succes
		self.info = info
		self.failure = failure
	}
}

struct VAuth {
	private static let auth = Auth.auth()
	
	static func signIn(email:String, password: String)async -> AuthResult<(uid:String,emailVerified:Bool)> {
		 do {
			 let authDataResult = try await auth.signIn(withEmail: email, password: password)
			 let user = authDataResult.user
			 return .init(succes: true,info: (uid:user.uid,emailVerified:user.isEmailVerified))
		 }
		 catch {
			 return .init(failure: .init(error: error))
		 }
	 }
	
	static func checkExistence()async -> AuthResult<User> {
		 
		guard let user = auth.currentUser else{
			return .init(succes: true, info: nil)
		}
		do {
			try await user.reload()
		}catch{
			print("Error al recargar al usuario ")
			self.logOut()
			return .init(failure: .init(error: error))
		}
		guard let userReloaded = auth.currentUser else{
			return .init(succes: true, info: nil)
		}
		return .init(succes: true, info: userReloaded)
	}
	
	static func logOut() -> Bool{
		do{
			try auth.signOut()
			return true
		}catch{
			print("error al salir\(error)")
			return false
		}
	}
	static func createNewUser(email: String, password: String ) async -> AuthResult<User> {
		do{
			let createUserResult = try await auth.createUser(withEmail: email, password: password)
			return .init(succes: true,info: createUserResult.user)
		}catch{
			return .init(failure: .init(error: error)) 
		}
		 
 }
	
	static func verifyEmail() -> AuthResult<Bool> {
		var authResult = AuthResult<Bool>()
		return authResult
	}
	static func checkCodePasswordRestored() -> AuthResult<Bool> {
		var authResult = AuthResult<Bool>()
		return authResult
	}
	static func restorePassword() -> AuthResult<Bool> {
		var authResult = AuthResult<Bool>()
		return authResult
	}
	func updatePassword() -> AuthResult<Bool> {
		var authResult = AuthResult<Bool>()
		return authResult
	}
}
