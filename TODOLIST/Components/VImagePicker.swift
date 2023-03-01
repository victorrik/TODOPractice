//
//  VImagePicker.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 24/02/23.
//

import SwiftUI
import PhotosUI
import Photos



final class VImagePickerModel: ObservableObject {
	@Published var image: UIImage?
	@Published var imageData: VFiles?
	@Published var isLoading: Bool = false
	@Published var imageSelected: PhotosPickerItem? {
		didSet {
			if let imageSelected {
				isLoading = true
				loadTransferable(from: imageSelected)
			}
		}
	}
	private func loadDataFile(_ data: Data) {
		let result = PHAsset.fetchAssets(withLocalIdentifiers: [self.imageSelected!.itemIdentifier!], options: nil)
		if let asset = result.firstObject {
			
			let filename = asset.value(forKey: "filename") as! String
			print("asset.mediaType.rawValue.description-->\(asset.mediaType.rawValue.description)")
			 print("filename--->\(filename)")
			self.imageData = .init(filename: filename,
														 url: "",
														 width: asset.pixelWidth,
														 height: asset.pixelHeight,
														 data: data)
			self.isLoading = false
			 }
	}
	private func loadTransferable(from imageSelected: PhotosPickerItem) {
		imageSelected.loadTransferable(type: Data.self) { result in
			DispatchQueue.main.async {
				guard imageSelected == self.imageSelected else { return }
				
				switch result {
				case .success(let image):
					let uiImage = UIImage(data: image!)
					self.loadDataFile(image!)
					self.image = uiImage
					
				case .failure(let error):
					print("Error load transferable\(error)")
				}
				
				
			
			}
		}
	}
}

struct TestingImagePickerView: View {
	@StateObject var daPhoto = VImagePickerModel()
	
	var body: some View {
		VStack(spacing:20){
			Text("Viejon")
			VImagePicker(value:daPhoto,
									 loadingColor: .red,
									 
									 content: {
				Text("meo wmo")
			})
		}
	}
}

struct VImagePicker<Content: View>: View {
	@State var loadingSelection = false
	@ObservedObject var value:VImagePickerModel
	var loadingColor:Color = .white
	var loadingSize:Int = 2
	@State private var enabled = false
	@ViewBuilder var content: Content
	var filter: PHPickerFilter = .any(of: [.images,.videos ,.not(.livePhotos)])
	
	var body: some View {
		
		PhotosPicker(selection: $value.imageSelected,
								 matching: filter,
								 photoLibrary: .shared(),
								 label: {
			Group{
				if value.isLoading {
					ProgressView()
						.scaleEffect(CGSize(width: loadingSize, height: loadingSize))
						.progressViewStyle(CircularProgressViewStyle(tint: loadingColor))
					
				}else{
					content
				}
				
			}
			
		})
		.disabled(!enabled)
		.onAppear {
			PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
				enabled = status == .authorized
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
