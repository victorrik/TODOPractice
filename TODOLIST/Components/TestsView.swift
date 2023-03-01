//
//  TestsView.swift
//  TODOLIST
//
//  Created by Victor Andres Marcial on 27/02/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import UIKit


final class ViewModel: ObservableObject {
		@Published var images: [Image] = []
		@Published var dataImages: [UIImage] = []
		@Published var photoSelection: PhotosPickerItem? {
				didSet {
						if let photoSelection { loadTransferable(from: photoSelection) }
				}
		}
		
		private func loadTransferable(from photoSelection: PhotosPickerItem) {
				photoSelection.loadTransferable(type: Data.self) { result in
						DispatchQueue.main.async {
								guard photoSelection == self.photoSelection else { return }
								switch result {
								case .success(let image):
										let uiImage = UIImage(data: image!)
									self.dataImages.append(uiImage!)
										self.images.append(Image(uiImage: uiImage!))
								case .failure(let error):
										print("Error load transferable\(error)")
										self.images.append(Image(systemName: "multiply.circle.fill"))
								}
						}
				}
		}
	
	func removeThis(image:Image)  {
		if let index = images.firstIndex(of: image) {
			images.remove(at: index)
		}
		
	}
}
extension Image: Identifiable {
		public var id: String { UUID().uuidString }
}
struct TestsView: View {
	// Get a reference to the storage service using the default Firebase App
	private let storageRef = Storage.storage().reference()
	@StateObject var viewModel = ViewModel()
	@State var selectedItems: [PhotosPickerItem] = []
	@State var elWidth:String = "500"
	
	func resizeImage(image: UIImage) -> UIImage? {
			let newWidth = CGFloat(Int(elWidth)!)
			let scale = newWidth / image.size.width
			let newHeight = image.size.height * scale
			UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
			image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			return newImage
	}
	func loadToStorage()  {
		print("Inicia carga")
		let imageToUpload = viewModel.dataImages.first!
		let milli = Int(Date().timeIntervalSince1970.rounded())
		let path = "\(milli).jpeg"
		let imagesRef = storageRef.child(path)
		let datajpeg = resizeImage(image: imageToUpload )!.jpegData(compressionQuality: 0.5)

		print("datajpeg--->\(datajpeg)")
		let metadataStore = StorageMetadata()
		metadataStore.contentType = "image/jpeg"
		
		print("metadataStore-->\(metadataStore)")
		imagesRef.putData(datajpeg!, metadata: metadataStore) { (metadata, error) in
			guard let metadata = metadata else {
				// Uh-oh, an error occurred!
				print("Uh-oh, an error occurred!-->\(error)")
				return
			}
			// Metadata contains file metadata such as size, content-type.
			let size = metadata.size
			// You can also access to download URL after upload.
			imagesRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					// Uh-oh, an error occurred!
					print("URL!-->\(error)")
					return
				}
				print("urlDescarga->\(downloadURL)")
			}
		}
	}
	var body: some View {
		VStack {
			PhotosPicker(selection: $viewModel.photoSelection,
									 matching: .images,
									 photoLibrary: .shared()) {
					Label("Selecciona una Foto", systemImage: "photo.on.rectangle.angled")
			}
			VInput(value: $elWidth, labelPlaceholder: "El nuevo ncho")
				
			List{
				ForEach(viewModel.images, content: {  image in
					HStack{
						image
								.resizable()
								.scaledToFit()
								.frame(width: 120, height: 120)
						Button("Eliminadme") {
							viewModel.removeThis(image: image)
						}
						.buttonStyle(.borderedProminent)
						Button("Subidme") {
							loadToStorage()
						}
						.buttonStyle(.borderedProminent)
					}
				})
			}
				
		}
	 }
}

struct TestsView_Previews: PreviewProvider {
    static var previews: some View {
        TestsView()
    }
}
