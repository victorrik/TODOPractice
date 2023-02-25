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
				Color.blue
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
	let placeHolder:String
	//@State var showColor:Bool = false
	func valuatingExternalDate() {
		if date != nil {
			internalDate = date!
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
		.frame(maxWidth: .infinity)
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
						isShowing = false
					}
				VStack{
					Spacer()
					VStack{
						HStack{
							Button("Cancel") {
								isShowing = false
							}
							.foregroundColor(Color("AccentColor"))
							Spacer()
							Button("Done") {
								date = internalDate
								isShowing = false
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
					
				}
				
			}
			.onAppear{
				
				//UIView.setAnimationsEnabled(true)
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
//struct DatePickerTextField: UIViewRepresentable {
//	private let textField = UITextField()
//	private let datePicker = UIDatePicker()
//	private let helper = Helper()
//	private let dateFormatter: DateFormatter = {
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "dd/MM/YYYY"
//		return dateFormatter
//	}()
//
//	public var placeholder: String
//	@Binding public var date: Date?
//
//	func makeUIView(context: Context) -> UITextField {
//		self.datePicker.preferredDatePickerStyle = .wheels
//		self.datePicker.datePickerMode = .dateAndTime
//		self.datePicker.timeZone = NSTimeZone.local
//		self.datePicker.tintColor = .red
//		self.datePicker.setValue(UIColor.red, forKeyPath: "textColor")
//		self.datePicker.setValue(false, forKey: "highlightsToday")
//
//		self.datePicker.addTarget (
//			self.helper,
//			action: #selector (self.helper.dateValueChanged), for:
//					.valueChanged)
//		self.textField.placeholder = self.placeholder
//		self.textField.inputView = self.datePicker
//
//		// Accessory View
//		let toolbar = UIToolbar ( )
//		toolbar.sizeToFit ()
//		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self.helper, action: #selector (self.helper.doneButtonAction))
//		toolbar.setItems([flexibleSpace, doneButton], animated: true)
//		//toolbar.barTintColor = .red
//		self.textField.inputAccessoryView = toolbar
//
//		self.helper.dateChanged = {
//			self.date = self.datePicker.date
//		}
//
//		self.helper.doneButtonTapped = {
//			if self.date == nil {
//				self.date = self.datePicker.date
//			}
//			self.textField.resignFirstResponder()
//		}
//		return self.textField
//	}
//
//	func updateUIView(_ uiView: UITextField, context: Context) {
//		if let selectedDate = self.date {
//			uiView.text = self.dateFormatter.string(from: selectedDate)
//		}
//	}
//
//
//	func makeCoordinator () -> Coordinator {
//		Coordinator ()
//	}
//
//	class Helper {
//		public var dateChanged: (() -> Void)?
//		public var doneButtonTapped: (() -> Void)?
//		@objc func dateValueChanged() {
//			self.dateChanged?()
//		}
//		@objc func doneButtonAction() {
//			self.doneButtonTapped?()
//		}
//	}
//
//	class Coordinator{
//
//	}
//}
struct VDatePicker_Previews: PreviewProvider {
	static var previews: some View {
		TestingDatePickerView()
	}
}
