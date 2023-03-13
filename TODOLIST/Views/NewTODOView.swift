//
//  NewTODOView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 16/02/23.
//

import SwiftUI

enum Meow {
	case ratas
}
struct TestingNewTODOView: View {
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


extension View {
	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content) -> some View {
			
			ZStack(alignment: alignment) {
				placeholder().opacity(shouldShow ? 1 : 0)
				self
			}
		}
}


struct NewTODOView: View {
	@Binding var isShowing:Bool
	
	@ObservedObject var homeViewModel:HomeViewModel
	@ObservedObject var buttonRef = VButtonRef()
	@State private var  title:String = ""
	@State private var description:String = ""
	@State private var urgentLevel:UrgentLevels = .normal
	@State private var date:Date? = nil
	@StateObject var file = VImagePickerModel()
	@State private var enabled = false
	
	
	func checkAndSaveNote() {
		buttonRef.handleLoading(true)
		homeViewModel.createNewNote(title: title,
																description: description,
																urgentLevel:urgentLevel,
																deadline: date,
																file: file.imageData
		){ result in
			buttonRef.handleLoading(false)
			if !result.succes{
				return
			}
			isShowing = false
			title = ""
			description = ""
			urgentLevel = .normal
			date = nil
			file.image = nil
			
			
			enabled = false
			print("result->\(result)")
		}
		
	}
	
	var body: some View {
		LargeModal(isShowing: $isShowing){
			ScrollView{
				
				TextField("", text: $title)
					.accentColor(.white)
					.frame(height: 48)
					.foregroundColor(.white)
					.font(.custom("Montserrat", size: 16))
					.tint(.white)
					.placeholder(when: title.isEmpty) {
						VFont("Title",type:.b1)
							.foregroundColor(.white)
					}
					.padding(.horizontal,16)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white,lineWidth: 2)
					}
				
				VTextArea(value: $description)
					.accentColor(.white)
					.placeholder(when: description.isEmpty, alignment: .topLeading) {
						VFont("Description",type:.b1)
							.foregroundColor(.white)
							.offset(x:6,y:8)
					}
					.padding(8)
					.foregroundColor(.white)
					.font(.custom("Montserrat", size: 16))
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white,lineWidth: 2)
					}
					.frame(minHeight: 150 )
				
				
				HStack(spacing:16){
					HStack{
						VDatePicker(date: $date,placeHolder: "")
							.frame(height: 48)
							.foregroundColor(.white)
						VIcons(name:.calendar,color: .white.opacity( date == nil ? 0.5 : 1), size: 24)
					}
					.placeholder(when: date == nil, placeholder: {
						VFont("Deadline (Optional)",type:.b1)
							.foregroundColor(.white.opacity( date == nil ? 0.5 : 1))
					})
					.padding(.horizontal,16)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white.opacity( date == nil ? 0.5 : 1),lineWidth: 2)
					}
					
					Menu(content: {
						Picker(selection: $urgentLevel,label: EmptyView() ){
							ForEach(UrgentLevels.allCases, id: \.self) { value in
								Text(value.rawValue).tag(value)
							}
						}
					},label: {
						HStack(spacing:5){
							Text("Level:")
								.font(.custom("Montserrat", size: 16))
							
							Text(urgentLevel.rawValue)
								.fontWeight(.semibold)
								.font(.custom("Montserrat", size: 16))
								.frame(maxWidth: .infinity)
								
						}
						.padding(.horizontal,10)
						.foregroundColor(.white)
						.frame(width: 130, height: 48)
						
					})
					.background {
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(.white ,lineWidth: 2)
					}
				}
				VStack{
					VImagePicker(value: file ){
						if file.image != nil {
							Image(uiImage: file.image!)
								.resizable()
								.scaledToFill()
								.frame(height: (125 - 8))
								.frame(maxWidth: .infinity)
								.clipped()
								.cornerRadius(6)
								.padding(.horizontal,4)
							
						}else{
							VIcons(name:.photo,color: .white.opacity( title.isEmpty ? 0.5 : 1), size: 24)
							VFont("Add Image (Optional)",type:.b1)
								.foregroundColor(.white.opacity( title.isEmpty ? 0.5 : 1))
								.offset(x:16)
							
						}
					}
					.frame(height: 125)
					.frame(maxWidth: .infinity)
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
		TestingNewTODOView()
	}
}
