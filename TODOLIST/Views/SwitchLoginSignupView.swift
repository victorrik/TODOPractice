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
	 
    var body: some View {
			VStack{
				if self.rootView == .signup {
					SignUpView(rootView: $rootView)
						.transition(.backslide)
				} else {
					LoginView(rootView: $rootView)
						.transition(.backslide)
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
