//
//  SignUpView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct SignUpView: View {
	
	@EnvironmentObject var userModel:UserModel
	@Binding var rootView : RootView
	@ObservedObject var buttonRef:VButtonRef = VButtonRef()
	@ObservedObject var inputEmailRef:VInputRef = VInputRef()
	@ObservedObject var inputUsernameRef:VInputRef = VInputRef()
	@ObservedObject var inputPasswordRef:VInputRef = VInputRef()
	
	@State var email:String = ""
	@State var username:String = ""
	@State var password:String = ""
	
	func startSignIn()async {
		buttonRef.handleLoading(true)
		let resultSignIn = await VAuth.createNewUser(email: email, password: password)
		buttonRef.handleLoading(false)
		guard let userSigned = resultSignIn.info else{
			let resultFail = resultSignIn.failure!
			print("errores->\(resultFail)")
			switch resultFail.code {
			case .invalidEmail, .missingEmail, .emailAlreadyInUse:
				inputEmailRef.showCaption(resultFail.description)
				break
			case .weakPassword, .wrongPassword:
				inputPasswordRef.showCaption(resultFail.description)
				break;
			default:
				print("Caso no cachado")
				break
			}
			return
		}
		print("Usuario logeado->\(userSigned.uid)")
		withAnimation(.easeOut(duration: 0.32)) {
			userModel.userIsLogged = true
		}
		
	}
	//.frame(minHeight: 187)
	var body: some View {
			VStack{
				Image("todo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 187)
					.frame(minHeight: 187 / 2)
					.padding(.top,50)
				 Spacer()
				VStack(spacing: 16){
					
					VInput(value: $email,
								 labelPlaceholder: "Email",
								 autocapitalization: .never,
								 keyboardType: .emailAddress,
								 ref:inputEmailRef)
					
					VInput(value: $username,
								 labelPlaceholder: "Username", 
								 ref:inputUsernameRef)
					
					VInput(value: $password,
								 labelPlaceholder: "Password",
								 autocapitalization: .never,
								 type:  .password, 
								 ref: inputPasswordRef)
					 
					 
					
					VButton("Sign up",action: {
						Task{
							await startSignIn()
						}
					}, ref:buttonRef)
					HStack{
						VFont("Have an account?")
							.foregroundColor(.V272727.opacity(0.4))
						Button(action:{
							withAnimation(.default){
								rootView = .login
							}
						}, label: {
							VFont("Login")
						})
					}
				}
			}
			.padding()
	}
}

struct SignUpView_Previews: PreviewProvider {
	static var previews: some View {
		SignUpView(rootView: .constant(.signup))
	}
}
