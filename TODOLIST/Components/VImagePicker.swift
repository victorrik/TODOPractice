//
//  VImagePicker.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 24/02/23.
//

import SwiftUI
import PhotosUI

struct TestingImagePickerView: View {
	@State var daPhoto:PhotosPickerItem?
	 
	var body: some View {
		VStack(spacing:20){
			Text("Viejon")
			VImagePicker(value:$daPhoto)
		}
	}
}
struct VImagePicker: View {
	@State var loadingSelection = false
	@Binding var value:PhotosPickerItem?
	
	var body: some View {
		VStack(spacing:50){
			
			PhotosPicker(selection: $value,matching: .any(of: [.images,.not(.livePhotos)])) {
				Image(systemName: "photo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 100)
			}.onChange(of: value) { newItem in
				Task {
						 if let data = try? await newItem?.loadTransferable(type: Data.self) {
								 print("data--->\(data)")
						 }
				 }
			}

		}
 
	}
}

//struct VImagePicker: View {
//	@State var openCameraRoll = false
//	@State var imageSelected = UIImage()
//	var body: some View {
//		VStack(spacing:50){
//			Image(uiImage: imageSelected)
//
//				.resizable()
//				.aspectRatio(contentMode: .fit)
//				.frame(width: 100)
//
//			Button {
//				openCameraRoll = true
//			} label: {
//				Image(systemName: "photo")
//					.resizable()
//					.aspectRatio(contentMode: .fit)
//					.frame(width: 100)
//
//			}
//
//		}
//		.sheet(isPresented: $openCameraRoll) {
//			ImagePicker(selectedImage: $imageSelected, sourceType: .camera)
//		}
//	}
//}

struct VImagePicker_Previews: PreviewProvider {
	static var previews: some View {
		TestingImagePickerView()
	}
}
