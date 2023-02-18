//
//  ProfileView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 17/02/23.
//

import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var userModel:UserModel
    var body: some View {
			Button("Amonos paps que aqui espantan"){
				userModel.logout()
			}.buttonStyle(.borderedProminent)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
