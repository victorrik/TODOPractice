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
	var code:String
}

struct AuthResult<InfoResult>{
	var succes: Bool
	var info: InfoResult?
	var failure:AuthError
	
	init(succes: Bool = false,info: InfoResult? = nil, failure: AuthError = AuthError(message: "", code: "")) {
		self.succes = succes
		self.info = info
		self.failure = failure
	}
}

struct VAuth {
	private static let auth = Auth.auth()
	
	static private func handleError(error:Error) -> AuthError {
		let message = error.localizedDescription
		let handleError = error as NSError
		var code = ""
		switch AuthErrorCode.Code(rawValue: handleError.code){
		case .invalidEmail:
			code = "Corrreo no valido"
		case .wrongPassword:
			code = "Contraseña incorrecta"
		default:
			code = "Sos pelotudo"
		}
		return AuthError(message: message, code: code)
	}
	
	static func signIn(email:String, password: String)async -> AuthResult<(uid:String,emailVerified:Bool)> {
		var authResult = AuthResult<(uid:String,emailVerified:Bool)>()
		 do {
			 
			 let authDataResult = try await auth.signIn(withEmail: email, password: password)
			 let user = authDataResult.user
			 authResult.succes = true
			 
			 print("Signed in as user \(user.uid), with email: \(user.email!)")
			 authResult.info = (uid:user.uid,emailVerified:user.isEmailVerified)
			 return authResult
		 }
		 catch {
			 //print("There was an issue when trying to sign in: \(error)")
			 authResult.failure = self.handleError(error: error)
			 return authResult
		 }
	 }
	
	static func checkExistence()async -> AuthResult<User> {
		var authResult = AuthResult<User>()
		
		guard let user = auth.currentUser else{
			authResult.succes = true
			return authResult
		}
		do {
			try await user.reload()
		}catch{
			print("Error al recargar al usuario \(error.localizedDescription)")
		}
	
		authResult.info = auth.currentUser
		return authResult
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
