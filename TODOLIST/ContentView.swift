//
//  ContentView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject  var userModel:UserModel = UserModel()
	 
	@State private var moveImage = false
	@State private var showLobby = false
	
	func checkUserExistence()async {
		let resultAuth = await VAuth.checkExistence()
		guard let user = resultAuth.info else{
			withAnimation(.easeOut(duration: 0.5)) {
				self.moveImage = true
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.showLobby = true
			}
			return
		}
		withAnimation(.easeOut(duration: 0.5)) {
			userModel.userIsLogged = true
			self.showLobby = true
		 }
	}
	
    var body: some View {
			ZStack{
				if userModel.userIsLogged {
					VStack{
						HomeView()
							.environmentObject(userModel)
					}
					.transition(.backslide)
				}
				else if showLobby{
					NavigationView{
						SwitchLoginSignupView()
							.environmentObject(userModel)
					}
					.navigationViewStyle(StackNavigationViewStyle())
					.navigationBarHidden(true)
					.transition(.backslide)
				}else{
					VStack{
						Image("todo")
						 .resizable()
						 .aspectRatio(contentMode: .fit)
						 .frame(width: 187)
						 .padding(.top,50)
						if moveImage{
							Spacer()
						}
					}
					.frame(maxWidth: .infinity,maxHeight: .infinity)
					.background(Color.white)
					.transition(.backslide)
					.padding()
					
					.task {
						await checkUserExistence()
					}
				}
			}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
