//
//  SignUpView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct SignUpView: View {
	@Binding var rootView : RootView
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
				VInput(value: $email, labelPlaceholder: "Username")
				VInput(value: $password, labelPlaceholder: "Password",iconSuffix: showPassword ? .eyeSlash : .eye,iconSuffixAction: {
					showPassword.toggle()
				})
				VInput(value: $password, labelPlaceholder: "Confirm Password",iconSuffix: showPassword ? .eyeSlash : .eye,iconSuffixAction: {
					showPassword.toggle()
				})
				
				VButton("Sign up",action: {
					print("meow")
				})
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
