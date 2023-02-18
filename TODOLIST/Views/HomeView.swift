//
//  HomeView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI

struct HomeView: View {
	@State var showNewTODO: Bool = false;
	
	var body: some View {
		ZStack{
			NavigationView{
				VStack{
					HStack(alignment: .center){
						Image("logosimplerojo")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 25)
						VFont("List of todo",type: .h3)
							.foregroundColor(.VF76C6A)
						Spacer()
						VIcons(name: .lineDecreaseCircle,color: .VF76C6A, size: 30)
							.font(.system(size: 20,weight: .medium))
					}
					
					Spacer()
					HStack{
						Spacer()
						Button(action: {
							showNewTODO = true
						}, label: {
							VStack{
								VIcons(name:.plus,color: .white, size: 35)
									.font(.system(size: 20,weight: .medium))
								
							}
							.frame(width: 60,height: 60)
							.background(Color.VF76C6A)
							.cornerRadius(100)
							
						})
					}
				}
				.padding()
				.toolbar {
					
					ToolbarItem(placement:ToolbarItemPlacement.navigationBarLeading) {
						VFont("TO DO LIST",type: .h4)
							.foregroundColor(.VF79E89)
					}
					ToolbarItem {
						NavigationLink(destination: ProfileView(), label: {
							VIcons(name:.gearshape ,color: .black, size: 30)
								.font(.system(size: 20,weight: .medium))
						})
					}
					
				}
				//.navigationTitle("meow")
				.navigationBarTitleDisplayMode(.inline)
				.navigationViewStyle(.stack)
				
			}
			NewTODOView(isShowing: $showNewTODO)
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
			.previewDisplayName("iPhone 14 Pro Max")
		HomeView()
			.previewDevice(PreviewDevice(rawValue: "iPhoneTanquesito"))
			.previewDisplayName("iPhone SE")
	}
}
