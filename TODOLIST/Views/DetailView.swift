//
//  DetailView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI

struct TestingDetail:View {
	let constant: NoteModel = NoteModel(userId: "12",
																		 description: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin efficitur lectus dolor, nec sollicitudin augue vestibulum quis. Nam facilisis odio vitae eros pretium, varius dapibus risus vehicula. Praesent commodo tortor ac metus porttitor, nec rhoncus arcu volutpat. Praesent iaculis ante vel est consequat, nec hendrerit odio feugiat. Sed sem diam, rutrum a tempus in, congue ac augue. Proin venenatis efficitur vehicula. Sed iaculis semper enim. Fusce bibendum vel nisl a sollicitudin. Vestibulum imperdiet rhoncus pretium.

Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum odio nulla, fermentum a sollicitudin eu, facilisis nec nisi. Ut nisi ante, dapibus id tortor a, dapibus viverra dolor. Aliquam pretium auctor mi, id iaculis turpis volutpat vitae. Praesent a tellus ut nulla fermentum sodales in imperdiet elit. Aenean bibendum maximus urna, in ullamcorper mauris lobortis eu. Nulla in magna aliquam, consectetur est eu, congue neque. Ut feugiat mi sapien, vitae sollicitudin nisi dapibus nec. Pellentesque non sapien eros. Maecenas fermentum tristique lectus, eu euismod purus feugiat faucibus. Morbi ultrices ex eu est dignissim, in gravida ex facilisis. Curabitur ligula lacus, efficitur sit amet scelerisque at, porttitor ac magna.

Mauris ut nisi lorem. Etiam sodales nisi lacus, condimentum ultrices sem vulputate vel. Fusce sodales eget odio eget sagittis. Mauris vehicula facilisis tincidunt. Duis euismod non nulla in rutrum. Fusce facilisis justo non hendrerit malesuada. Mauris luctus blandit neque, in aliquam quam congue id.

Nulla eu enim eu arcu varius ultricies quis quis eros. Vestibulum imperdiet mauris ut magna mollis vehicula. Vivamus magna eros, laoreet a massa ut, ornare tincidunt ex. Nam malesuada congue sodales. Etiam id blandit nunc, at porta ligula. Nunc sapien ante, finibus vitae tincidunt ut, volutpat nec arcu. Fusce ac pellentesque ligula.

Maecenas in sodales est. Quisque volutpat risus tellus, a malesuada mauris malesuada eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam feugiat eget elit sit amet congue. Fusce scelerisque purus vitae mauris tristique, quis rhoncus turpis volutpat. Phasellus eu bibendum nulla. Integer dapibus felis id quam tempus vehicula. Quisque pulvinar porttitor mi, sit amet interdum sapien.
""",
																		 title: "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit",
																			file:.init(filename: "filename",
																								 url: "https://firebasestorage.googleapis.com/v0/b/victorrik-1.appspot.com/o/src%2Fog_principal.jpg?alt=media",
																								 width: 100,
																								 height: 100)
																		)
	
	@ObservedObject var homeViewModel:HomeViewModel = HomeViewModel()
	@State private var currentViewTag: String? = nil
	var body: some View {
		NavigationView{
			VStack{
				NavigationLink(destination: DetailView(noteInfo: constant,
																							 viewTag:$currentViewTag,
																							 homeViewModel:homeViewModel)) {
					Text("Ir al detalle")
				}
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
	}
}

struct DetailView: View {
	// define this in your Detail view
	@Environment(\.presentationMode) var presentationMode
	let noteInfo:NoteModel
	@Binding var viewTag: String?
	@ObservedObject var homeViewModel : HomeViewModel
	@State private var showAlert:Bool = false
	
    var body: some View {
			VStack(alignment:.leading){
				HStack{
					VFont(noteInfo.title,type: .h4)
						.padding(0)
				}
				.padding()
				
				ScrollView{
					VFont(noteInfo.description,type: .b1)
						.padding(.horizontal)
					if noteInfo.file != nil {
						AsyncImage(url: noteInfo.getURLImage() ) { image in
							image
								.resizable()
								.scaledToFit()
								.clipped()
						} placeholder: {
							VStack{
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle(tint: .white))
							}
							.frame(width:50,height: 50)
						}
						.frame(width:.infinity,height: 200)
						.background {
								Color.gray.opacity(0.2)
							}
						.cornerRadius(8)
						.padding(.horizontal)
					}
				}
				
				HStack{
					Spacer()
					VFont(noteInfo.createdDate(),type: .b2)
					Spacer()
				}
				.padding(.top)
			}
			
			.toolbar {
				 
				ToolbarItem {
					Button(action: {
						showAlert = true
					}, label: {
						VIcons(name:.trash ,color: .black, size: 30)
							.font(.system(size: 20,weight: .medium))
					})
				}
			}
			.alert("Delete note",
							 isPresented: $showAlert,
								 actions: {
						Button("Delete note", role: .destructive, action: {
							homeViewModel.deleteNote(note: noteInfo) { result in
								if (result.fail != nil){
									
								}else{
									self.presentationMode.wrappedValue.dismiss()
									viewTag = nil
								}
							}
						})

					},
								 message: {
				Text("Do you want to delete the \"\(noteInfo.title.count > 10 ? noteInfo.title.prefix(10) + "..." : noteInfo.title)\" note?")
					}
					)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
			TestingDetail()
    }
}
