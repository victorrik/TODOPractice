//
//  LoginView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct LoginView: View {
	@Binding var rootView: RootView
	@State var email:String = ""
	@State var password:String = ""
	@State var showPassword:Bool = false
	var body: some View {
		VStack{
			Image("todo")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 187)
				.padding(.top,50)
			Spacer()
			VStack(spacing: 16){
				VInput(value: $email, labelPlaceholder: "Email")
				VInput(value: $password, labelPlaceholder: "Password",iconSuffix: showPassword ? .eyeSlash : .eye,iconSuffixAction: {
					showPassword.toggle()
				})
				
				HStack{
					Spacer()
					NavigationLink(destination: ForgotPasswordView(),
												 label:{
						VFont("Forgot Passsword",type: .small)
							.foregroundColor(.V272727.opacity(0.5))
					} )
					
					
				}
				.frame(maxWidth: .infinity)
				VButton("Login",action: {
					print("meow")
				})
				HStack{
					VFont("Don't have an account?")
						.foregroundColor(.V272727.opacity(0.4))
					Button(action:{
						withAnimation(.default){
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
