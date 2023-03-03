//
//  TODOLISTApp.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI
import UIKit
import Firebase
//import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
//import FirebaseFunctions

extension Color {
	public static let VF79E89:Color = Color(red: 0.969, green: 0.62, blue: 0.537)
	public static let VF76C6A:Color = Color(red: 0.969, green: 0.424, blue: 0.416)
	public static let V272727:Color = Color(red: 0.154, green: 0.154, blue: 0.154)
	public static let VF0F0F0:Color = Color(red: 0.94, green: 0.94, blue: 0.94)
	public static let VFFFFFF:Color = Color(red: 1, green: 1, blue: 1)
}

extension AnyTransition {
	static var backslide: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .move(edge: .trailing),
			removal: .move(edge: .leading)
		)
	}
	static var navigationSlide: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .move(edge: .trailing),
			removal:  .offset(x:  -(UIScreen.main.bounds.size.width * 0.33) )
		)
	}
	static var bottomslide: AnyTransition {
		AnyTransition.asymmetric(
			insertion: .move(edge: .bottom),
			removal: .move(edge: .bottom).combined(with: .opacity.animation(.easeOut.delay(0.25)))
		)
	}
}

extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}


struct VError {
	var message:String
	var code:String
	init(error:Error) {
		
		self.message = error.localizedDescription
		self.code = "meow"
	}
}

struct VResult<InfoResult>{
	let succes: Bool
	let info: InfoResult?
	let fail:VError?
	
	init(succes: Bool = false,info: InfoResult? = nil, fail: VError? = nil ) {
		self.succes = succes
		self.info = info
		self.fail = fail
	}
}

enum Configuration {
	enum Error: Swift.Error{
		case missingKey , invalidValue
	}
	enum CustomValues: String {
		case IP = "CT_IP_HOST"
	}
	static func value<T>(for key: CustomValues) throws -> T where T: LosslessStringConvertible{
		guard let objet = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
			throw Error.missingKey
		}
		switch objet {
		case let value as T:
			return value
		case let string as String:
			guard let value = T(string) else { fallthrough }
			return value
		default:
			throw Error.invalidValue
		}
	}
}


@main
struct TODOLISTApp: App {
	
	let ipHosting:String = try! Configuration.value(for: .IP)
	
	init(){
		FirebaseApp.configure()
		#if DEVELOPMENT
				print(
				"""
				*********
				DEVELOPMENT MODE IS ON
				*********
				"""
				)
				Auth.auth().useEmulator(withHost:"192.168.100.37", port:4009)
				//Functions.functions().useEmulator(withHost:"192.168.100.37", port:5008)
				let settings = Firestore.firestore().settings
				settings.host = "192.168.100.37:4007"
				settings.isPersistenceEnabled = false
				settings.isSSLEnabled = false
				Firestore.firestore().settings = settings
		#elseif DEBUG
				print(
				"""
				*********
				DEBUGGIN MODE IS ON
				*********
				"""
				)
		#else
				print(
				"""
				*********
				RELEASE THE KRAKEN
				*********
				"""
				)
		#endif
	}
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
