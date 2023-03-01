//
//  VDatePicker.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 21/02/23.
//

import SwiftUI

struct TestingDatePickerView: View {
	@State var date:Date? = nil
	@State var dateTes:Date = Date()
	@State var isShowing = true
	var body: some View {
		VStack{
			
			ZStack(alignment:.leading){
				Color.blue.ignoresSafeArea()
				if date == nil {
					VFont("Deadline (Optional)",type:.b1)
						.foregroundColor(.red.opacity( date != nil ? 0.5 : 1))
						.offset(x:16)
				}
				
				HStack{
					VDatePicker(date: $date,placeHolder: "")
						.frame(height: 48)
					Spacer()
					VIcons(name:.calendar,color: .red.opacity( date != nil ? 0.5 : 1), size: 24)
				}
				.padding(.horizontal,16)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.strokeBorder(.red.opacity( date != nil ? 0.5 : 1),lineWidth: 2)
				}
			}
		}
	}
}
struct VDatePicker: View {
	@Binding var date:Date?
	@State var internalDate:Date = Date()
	@State var isShowing:Bool = false
	@State var showWheel:Bool = false
	let placeHolder:String
	//@State var showColor:Bool = false
	func valuatingExternalDate() {
		if date != nil {
			internalDate = date!
		}
	}
	
	func closeModal() {
		withAnimation(){
			showWheel = true
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ){
			isShowing = false
			showWheel = false
		}
		 
	}
	
	var body: some View {
		
		
		HStack{
			if date != nil {
				Text(date!, style: .date)
				Spacer()
			}else{
				Rectangle()
					.frame(maxWidth: .infinity,maxHeight: .infinity)
					.foregroundColor(.white.opacity(0.00001))
			}
		} 
		.onAppear{
			valuatingExternalDate()
		}
		.onTapGesture {
			isShowing = true
			
		}
		.fullScreenCover(isPresented: $isShowing) {
			ZStack{
				Color.black
					.opacity(0.00001)
					.edgesIgnoringSafeArea(.all)
					.onTapGesture {
						closeModal()
						
					}
				VStack{
						Spacer()
					if !showWheel{
						VStack{
							HStack{
								Button("Cancel") {
									closeModal()
								}
								.foregroundColor(Color("AccentColor"))
								Spacer()
								Button("Done") {
									date = internalDate
									closeModal()
								}
								.foregroundColor(Color("AccentColor"))
							}
							.padding(.horizontal)
							.padding(.top)
							
							Divider()
							DatePicker("", selection: $internalDate,displayedComponents: [.date])
								.datePickerStyle(.wheel)
								.labelsHidden()
								.colorInvert()
								.accentColor(.red)
								.colorMultiply(.red)
								.background(Color.white)
						}
						.background(Color.white)
						.transition(.bottomslide)
					}
					 
				}
				
				 
			}
			.background(BackgroundBlurView())
		}
		
	}
}
struct BackgroundBlurView: UIViewRepresentable {
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		// let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		DispatchQueue.main.async {
			view.superview?.superview?.backgroundColor = .clear
		}
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}


struct VDatePicker_Previews: PreviewProvider {
	static var previews: some View {
		TestingDatePickerView()
	}
}
