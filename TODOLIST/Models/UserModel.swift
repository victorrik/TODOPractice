//
//  UserModel.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import Foundation
import SwiftUI

struct UserApp {
	let email:String
	let username:String
	let uid:String
}
class UserModel: ObservableObject{
	@Published var user:UserApp?
	@Published var userIsLogged: Bool = false
	
	func logout() {
		withAnimation(.easeOut(duration: 0.5)) {
			self.userIsLogged = false
		 }
		VAuth.logOut()
	}
	func updateData(data:[String:Any]) -> Bool {
		print("Data to update->\(data)")
		return true
	}
}
