//
//  NoteCell.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 12/03/23.
//

import SwiftUI
struct TestinNoteCell:View {
	var body: some View {
		List{
			NoteCell(note:.init(userId: "",
													description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a leo risus. Nam dictum ornare neque at auctor. ",
													title: "Lorem Ipsum",
													file:.init(filename: "filename",
																		 url: "https://firebasestorage.googleapis.com/v0/b/victorrik-1.appspot.com/o/src%2Fducky_256.png?alt=media",
																		 width: 100,
																		 height: 100)))
			EmptyNoteCell()
			
		}
		.listStyle(.plain)
		.padding(.vertical)
	}
}

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
 


struct EmptyNoteCell:View{
	let phase: CGFloat = 0
	var body: some View{
		VShrimmer(centerColor: .VF76C6A.opacity(0.8),edgeColor: .VF76C6A)
			.frame(height: 100)
			.cornerRadius(12)
		.listRowSeparator(.hidden)
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
			
			VStack(alignment:.trailing){
				VIcons(name: .clock,color: .white, size: 20)
				Spacer()
				if note.file != nil {
					AsyncImage(url: note.getURLImage() ) { image in
						image
							.resizable()
							.scaledToFill()
							.frame(width:50,height: 50)
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
    }
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
			TestinNoteCell()
    }
}
