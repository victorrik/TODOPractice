//
//  HomeView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI
import FirebaseFirestore

 

extension View {
	func noteStyle (
		backgroundColor: Color
	) -> some View {
		self
			.padding(.vertical, 8)
			.padding(.leading, 16)
			.padding(.trailing, 10)
			.background{
			 backgroundColor
				}
		 .cornerRadius(12)
			
		}
}

struct NoteCell: View {
	let note: NoteModel
	 
	var body: some View{
		HStack(spacing:8){
			VStack(alignment:.leading,spacing: 8){
				Text(note.title)
					.fontWeight(.semibold)
					.font(.custom("Montserrat", size: 16) )
					.lineLimit(1)
				
				HStack{
					Text(note.description)
						.font(.custom("Montserrat", size: 14) )
						.multilineTextAlignment(.leading)
						.lineLimit(2)
				}
				Text(note.createdDate())
					.font(.custom("Montserrat", size: 11))
			}
			.foregroundColor(.white)
			Spacer()
			
			VStack{
				VIcons(name: .clock,color: .white, size: 20)
				Spacer()
				if note.file != nil {
					AsyncImage(url: note.getURLImage() ) { image in
						image
							.resizable()
							.scaledToFill()
							.frame(width:60,height: 40)
							.clipped()
							.cornerRadius(8)
					} placeholder: {
						VStack{
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: .white))
						}
						.frame(width:50,height: 50)
						.background {
							Color.white.opacity(0.2)
						}
						.cornerRadius(8)
					}
				}
			}
		}
		.noteStyle(backgroundColor: note.urgentColor())
		.listRowSeparator(.hidden)
		
		
	}
}

struct EmptyNoteCell:View{
	var body: some View{
		HStack{
			VStack(alignment:.leading,spacing: 8){
				Text("note.title")
					.fontWeight(.semibold)
					.font(.custom("Montserrat", size: 16) )
					.lineLimit(1)
				
				HStack{
					Text("note.description")
						.font(.custom("Montserrat", size: 14) )
						.multilineTextAlignment(.leading)
						.lineLimit(2)
				}
				Text("note.createdDate()")
					.font(.custom("Montserrat", size: 11))
			}
			.foregroundColor(.VF76C6A)
			Spacer()
		}
		.noteStyle(backgroundColor: Color.VF76C6A)
		.listRowSeparator(.hidden)
	}
}


struct HomeView: View {
	@State var showNewTODO: Bool = false;
	@ObservedObject var homeViewModel:HomeViewModel = HomeViewModel()
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
					
					if homeViewModel.loadingNotes {
						VStack{
							EmptyNoteCell()
							EmptyNoteCell()
							EmptyNoteCell()
							Spacer()
						}
					}else{
						List(homeViewModel.notes, id: \.id){ note in
							NoteCell(note: note)
							.listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
							.swipeActions(edge: .trailing) {
								Button(action: {
									print("deletamos")
								}, label: {
									VIcons(name: .trash, color: .white, size: 24)
								})
								.tint(.red)
							}
							
						}
						.listStyle(.plain)
					}
					
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
			NewTODOView(isShowing: $showNewTODO,
									homeViewModel: homeViewModel)
		}
		.onAppear{
			homeViewModel.getAllNotes()
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
