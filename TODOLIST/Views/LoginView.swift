//
//  LoginView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct LoginView: View {
	
	@EnvironmentObject var userModel:UserModel
	@Binding var rootView : RootView
	@ObservedObject var buttonRef:VButtonRef = VButtonRef()
	@ObservedObject var inputEmailRef:VInputRef = VInputRef()
	@ObservedObject var inputPasswordRef:VInputRef = VInputRef()
	
	@State var email:String = ""
	@State var password:String = ""
	
	func loginUser()async {
		buttonRef.handleLoading(true)
		let resultSignIn = await VAuth.signIn(email: email, password: password)
		buttonRef.handleLoading(false)
		guard let userSigned = resultSignIn.info else{
			let resultFail = resultSignIn.failure!
			print("errores->\(resultFail)")
			switch resultFail.code {
			case .userNotFound, .userDisabled:
				inputEmailRef.showCaption(resultFail.description)
				break
			case .wrongPassword:
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
				
				
				VInput(value: $password,
							 labelPlaceholder: "Password",
							 autocapitalization: .never,
							 type:  .password,
							 ref: inputPasswordRef)
				
				HStack{
					Spacer()
					NavigationLink(destination: ForgotPasswordView(),
												 label:{
						VFont("Forgot Passsword",type: .small)
							.foregroundColor(.V272727.opacity(0.5))
					})
				}
				.frame(maxWidth: .infinity)
				VButton("Login",action: {
					Task{
						await loginUser()
					}
				},ref:buttonRef)
				HStack{
					VFont("Don't have an account?")
						.foregroundColor(.V272727.opacity(0.4))
					Button(action:{
						withAnimation(.easeOut(duration: 0.32)){
							rootView = .signup
						}
					}, label: {
						VFont("Sign up")
					})
				}
			}
		}
		.padding()
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(rootView: .constant(.login))
	}
}
