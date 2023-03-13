//
//  HomeView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI 

struct HeaderList: View {
	var body: some View {
		HStack(alignment: .center){
			Image("logosimplerojo")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 25)
			VFont("List of todo",type: .h3)
				.foregroundColor(.VF76C6A)
			Spacer()
//			VIcons(name: .lineDecreaseCircle,color: .VF76C6A, size: 30)
//				.font(.system(size: 20,weight: .medium))
		}
		.padding(.top)
		.padding(.horizontal)
	}
}

struct ButtonAdd: View {
	@Binding var showNewTODO:Bool

	var body: some View{
		VStack{
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
		.padding(.trailing)
	}
}

struct HomeView: View {
	@State var showNewTODO: Bool = false;
	@ObservedObject var homeViewModel:HomeViewModel = HomeViewModel()
	@State private var currentViewTag: String? = nil
	@State private var noteInfo: NoteModel = NoteModel(userId: "", description: "", title: "")
	@State private var showAlert: Bool = false
	
	let emptyLoad = Array(0...10)
	
	var body: some View {
		ZStack{
			NavigationView{
				ZStack{
					NavigationLink(destination: DetailView(noteInfo: noteInfo,
																								 viewTag:$currentViewTag,
																								 homeViewModel:homeViewModel
																								),
												 tag: "Detail",
												 selection: $currentViewTag,
												 label: { EmptyView() })
					VStack{
						HeaderList()
						ScrollView{
							if homeViewModel.loadingNotes {
								ForEach(emptyLoad,id:\.self) { data in
									EmptyNoteCell()
										.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
										.padding(.horizontal)
										.padding(.vertical, 8)
								}
							}else{
								ForEach(homeViewModel.notes, id: \.id) { note in
									LazyVStack{
										Button(action: {
											self.noteInfo = note
											currentViewTag = "Detail"
										}, label: {
											NoteCell(note: note)
										})
										.buttonStyle(.plain)
										.padding(.bottom,homeViewModel.notes.last?.id == note.id ? 70 : 8)
										.padding(.horizontal)
									}
									 
								}
							}
						}
					
					}
					
					ButtonAdd(showNewTODO: $showNewTODO)
				}
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
	}
}
