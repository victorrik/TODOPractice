//
//  SwitchLoginSignupView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

enum RootView {
	case login, signup
}
struct SwitchLoginSignupView: View {
	@State private var rootView: RootView = .login
	@State private var alternation:Bool = false
    var body: some View {
			VStack{
				if self.rootView == .signup {
					SignUpView(rootView: $rootView)
						.background(content: {
							Color.white
								.ignoresSafeArea()
								.shadow(color: Color.black.opacity(!alternation ? 0.2 : 0.0), radius: 100,x: -100)
						})
						.transition(.navigationSlide)
						.onAppear{
							withAnimation {
								alternation = false
							}
						}
				} else {
					LoginView(rootView: $rootView)
						.background(content: {
							Color.white
								.ignoresSafeArea()
								.shadow(color: Color.black.opacity(alternation ? 0.2 : 0.0), radius: 100,x: -100)

						})
						.transition(.navigationSlide)
						.onAppear{
							withAnimation {
								alternation = true
							}
						}
				}
			}
			.navigationBarHidden(true)
    }
}

struct SwitchLoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchLoginSignupView()
    }
}
