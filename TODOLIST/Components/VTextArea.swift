//
//  VTextArea.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 18/02/23.
//

import SwiftUI
struct TestVTextAreaView: View {
	var body : some View{
		VStack{
			VTextArea(value: .constant("meow meow"))
				.background(Color.red)
				.foregroundColor(.white)
		}
	}
}
struct VTextArea: View {
	
	@Binding var value:String
	@FocusState private var isFocused: Bool
	@ObservedObject var inputRef:VInputRef
	init(value: Binding<String>,
			 inputRef: VInputRef = VInputRef()) {
		self._value = value
		self.inputRef = inputRef
		UITextView.appearance().backgroundColor = .clear // First, remove the UITextView's backgroundColor.
	}
	
    var body: some View {
			if #available(iOS 16.0, *) {
						mainView.scrollContentBackground(.hidden)
				} else {
						mainView
				}
    }
		// rename body to mainView
		var mainView: some View {
				TextEditor(text: $value)
				.frame(minHeight: 200)
		}
}

struct VTextArea_Previews: PreviewProvider {
    static var previews: some View {
			TestVTextAreaView()    }
}
