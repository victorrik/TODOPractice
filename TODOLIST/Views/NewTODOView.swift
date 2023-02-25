//
//  NewTODOView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI

struct RoundedCornersShape: Shape {
	let corners: UIRectCorner
	let radius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect,
														byRoundingCorners: corners,
														cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
struct BackNewTODOView: View {
	@State var isShowing:Bool = true
	@ObservedObject var homeViewModel:HomeViewModel = HomeViewModel()
	
	var body: some View {
		ZStack{
			VStack{
				Button("Touch to show",action: {
					isShowing = true
					
				})
				.buttonStyle(.borderedProminent)
			}
			NewTODOView(isShowing: $isShowing,
									homeViewModel: homeViewModel)
		}
	}
}
/**
 .onTapGesture {
 withAnimation(.linear(duration: 0.1)){
 curHeight = minHeight
 }
 //isShowing = false
 }
 */
struct NewTODOView: View {
	@Binding var isShowing:Bool
	@ObservedObject var homeViewModel:HomeViewModel
	@ObservedObject var buttonRef = VButtonRef()
	@State private var title:String = ""
	@State private var description:String = ""
	@State private var date:Date? = nil
	@State private var file:String = ""
	
	func checkAndSaveNote() {
		homeViewModel.createNewNote(title: title, description: description, deadline: date){ result in
			if !result.succes{
				return
			}
			isShowing = false
			print("result->\(result)")
		}
		
	}
	
	var body: some View {
		LargeModal(isShowing: $isShowing){
			ScrollView{
				ZStack(alignment:.leading){
					if title.isEmpty {
						VFont("Title",type:.b1)
							.foregroundColor(.white)
							.offset(x:16)
					}
					
					VStack{
						TextField("", text: $title)
							.accentColor(.white)
							.frame(height: 48)
							.foregroundColor(.white)
							.font(.custom("Montserrat", size: 16))
							.tint(.white)
					}
					.padding(.horizontal,16)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white,lineWidth: 2)
					}
				}
				
				ZStack(alignment: .topLeading){
					if description.isEmpty{
						VFont("Description",type:.b1)
							.foregroundColor(.white)
							.offset(x:16,y:16)
					}
					
					VTextArea(value: $description)
						.accentColor(.white)
						.padding(8)
						.foregroundColor(.white)
						.font(.custom("Montserrat", size: 16))
						.background {
							RoundedRectangle(cornerRadius: 12)
								.strokeBorder(.white,lineWidth: 2)
						}
						.frame(minHeight: 200, maxHeight: .infinity)
				}
				ZStack(alignment:.leading){
					if date == nil {
							VFont("Deadline (Optional)",type:.b1)
							.foregroundColor(.white.opacity( date == nil ? 0.5 : 1))
								.offset(x:16)
					}
					
					HStack{
						VDatePicker(date: $date,placeHolder: "")
							.frame(height: 48)
							.foregroundColor(.white)
						VIcons(name:.calendar,color: .white.opacity( date == nil ? 0.5 : 1), size: 24)
					}
					.padding(.horizontal,16)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white.opacity( date == nil ? 0.5 : 1),lineWidth: 2)
					}
				}
				ZStack(alignment:.leading){
					if title.isEmpty {
							VFont("Add Image (Optional)",type:.b1)
							.foregroundColor(.white.opacity( title.isEmpty ? 0.5 : 1))
								.offset(x:16)
					}
					
					HStack{
						TextField("", text: $file)
							.accentColor(.white)
							.frame(height: 48)
							.foregroundColor(.white)
							.font(.custom("Montserrat", size: 16))
							.tint(.white)
						VIcons(name:.photo,color: .white.opacity( title.isEmpty ? 0.5 : 1), size: 24)
					}
					.padding(.horizontal,16)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white.opacity( title.isEmpty ? 0.5 : 1),lineWidth: 2)
					}
				}
				VButton("ADD TODO",type: .secondary,  action: {
					checkAndSaveNote()
				},ref:buttonRef)
			}
		}
		
	}
	
}

struct NewTODOView_Previews: PreviewProvider {
	static var previews: some View {
		BackNewTODOView()
	}
}
