//
//  ContentView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 15/02/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
			NavigationView{
				SwitchLoginSignupView()
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
