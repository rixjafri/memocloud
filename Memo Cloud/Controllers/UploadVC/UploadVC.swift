//
//  UploadVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 31/01/2025.
//

import UIKit
import FirebaseStorage
import PhotosUI
import AVFoundation

class UploadVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView! {
            didSet {
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.contentInsetAdjustmentBehavior = .never
                collectionView.registerNib(MediaCVC.identifier)
                
            }
        }
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var screenSubtitle: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet var categoryNames: UILabel!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var desView: UIView!
    @IBOutlet var memoTitle: UITextField!
    @IBOutlet var memoDescription: UITextView!
    @IBOutlet var galleryStack: UIStackView!
    
    
    var type = 0
    var selectedCategories: [List] = []
    var images: [UIImage] = []
    var videos: [URL] = []
    var paths: [String] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        self.galleryStack.isHidden = type == 0 ? true:false
        self.collectionView.isHidden = type == 0 ? true:false
        
        switch type {
        case 0:
            self.screenSubtitle.text = "Write Note"
        case 1:
            self.screenSubtitle.text = "Upload Photos"
        default:
            self.screenSubtitle.text = "Upload Video"
        }
    }
    

    @IBAction func dismissVc(_ sender: Any) {
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoriesTapped(_ sender: Any) {
        self.vibrate()
        
        self.presentCategories()
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        self.vibrate()
        
        switch type {
        case 1:
            self.photoCamera()
        default:
            self.videoCamera()
        }
        
    }
    
    func videoCamera(){
        
        // Check if the camera is available
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    print("Camera is not available")
                    return
                }
                
                let videoPicker = UIImagePickerController()
                videoPicker.sourceType = .camera
//                videoPicker.mediaTypes = [kUTTypeMovie as String] // Only allow video
                videoPicker.videoQuality = .typeHigh  // Set video quality
                videoPicker.delegate = self
                videoPicker.allowsEditing = false  // Optional: Set to true if you want editing
                
                present(videoPicker, animated: true, completion: nil)
    }
    
    func photoCamera(){
        DispatchQueue.global(qos: .userInitiated).async {
            // Perform heavy tasks here
            DispatchQueue.main.async {
                // Open the camera on the main thread
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    print("Camera is not available")
                }
            }
        }
    }
    
    @IBAction func galleryTapped(_ sender: Any) {
        self.vibrate()
        
        var config = PHPickerConfiguration()
        
        switch type {
        case 1:
            config.selectionLimit = 5
            config.filter = .images
        default:
            config.selectionLimit = 1
            config.filter = .videos
        }
        
                

                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
        
                present(picker, animated: true, completion: nil)
        
    }
    
    func presentCategories() {
        self.view.aj_hideDotLoadingIndicator()
        if let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .listVC) as? ListVC {
            vc.titleName = "Categories"
            
            let categories: [Categories] = self.categories
            vc.isMultiple = true
            vc.list = categories.map { category in
                List(
                    id: category.id,
                    name: category.name
                )
            }
            
            
            
           
            
            vc.onSelectionCompletion = { selectedList, type in
                // Handle the selected country here
                
                
                if self.selectedCategories != selectedList {
                    self.selectedCategories.removeAll()
                    self.selectedCategories = selectedList
                    
                    if self.selectedCategories.count == 0 {

                        self.categoryNames.text = "Select Categories"
                    }else{
                        let names = self.selectedCategories.map { $0.name }.joined(separator: ", ")
                        
                        self.categoryNames.text = names
                    }
                    
                }
                
                
            }
            
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
        
    }
    
    
    @IBAction func uploadMedia(_ sender: UIButton) {
        
//        // Reference to Firebase Storage
//                let storage = Storage.storage()
//                let storageRef = storage.reference()
//                
//                // Example: Upload a file
//                let fileURL = Bundle.main.url(forResource: "example", withExtension: "txt")!
//                let fileRef = storageRef.child("files/example.txt")
//                
//                fileRef.putFile(from: fileURL, metadata: nil) { metadata, error in
//                    if let error = error {
//                        print("Error uploading file: \(error.localizedDescription)")
//                    } else {
//                        print("File uploaded successfully!")
//                    }
//                }
        
        
        self.view.aj_showDotLoadingIndicator()
        
        
        switch type {
        case 0:
            self.uploadTextContent()
        case 1:
            self.uploadImagesSequentially(images: images)
        default:
            self.uploadVideosSequentially(videos: self.videos)
        }
        
        
        
        
    }
    
    func uploadVideosSequentially(videos: [URL], index: Int = 0) {
        // Check if all videos have been uploaded
        guard index < videos.count else {
            print("All videos uploaded successfully!")
            self.uploadTextContent()
            
            return
        }

        let videoURL = videos[index]

        self.saveAndUploadVideoToFirebase(videoURL: videoURL) { success in
            if success {
                print("Video \(index + 1) uploaded successfully!")
                // Start uploading the next video
                self.uploadVideosSequentially(videos: videos, index: index + 1)
            } else {
                print("Failed to upload video \(index + 1)")
            }
        }
    }

    func saveAndUploadVideoToFirebase(videoURL: URL, completion: @escaping (Bool) -> Void) {
        let fileName = UUID().uuidString + ".mov" // You can change the extension based on your video format
        let storage = Storage.storage()
        let storageRef = storage.reference().child("videos/\(fileName)")

        // Ensure file exists before uploading
        guard FileManager.default.fileExists(atPath: videoURL.path) else {
            print("Error: File does not exist at path \(videoURL.path)")
            completion(false)
            return
        }

        // Upload video to Firebase
        storageRef.putFile(from: videoURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading video: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Video uploaded: \(fileName)")

                // Get the download URL
                storageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                        self.paths.append(downloadURL.absoluteString)
                        completion(true)
                    } else {
                        print("Failed to retrieve download URL: \(error?.localizedDescription ?? "Unknown error")")
                        completion(false)
                    }
                }
            }
        }
    }
    
    func uploadTextContent(){
        
        if !validateEmpty(self.memoTitle.text!) {
            self.showMessage(title: "Oops! A title is a must. Don’t leave it blank!", state: .error)
            
        }else if !validateEmpty(self.memoDescription.text!) {
            self.showMessage(title: "Don’t forget the description. It can’t be empty!.", state: .error)
            
        }else if self.selectedCategories.count == 0 {
            self.showMessage(title: "Oops! You gotta pick a category. Don’t skip this step!", state: .error)
        }else {
            
            
            self.addContentApi()
        }
        
    }
    
    func uploadImagesSequentially(images: [UIImage], index: Int = 0) {
        // Check if all images have been uploaded
        guard index < images.count else {
            print("All images uploaded successfully!")
            self.uploadTextContent()
            
            return
        }

        let image = images[index]

        self.saveAndUploadImageToFirebase(image: image) { success in
            if success {
                
                print("Image \(index + 1) uploaded successfully!")
                // Start uploading the next image
                self.uploadImagesSequentially(images: images, index: index + 1)
            } else {
                print("Failed to upload image \(index + 1)")
            }
        }
    }
    
    func saveAndUploadImageToFirebase(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            completion(false)
            return
        }

        let fileName = UUID().uuidString + ".jpg"
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images/\(fileName)")

        // Upload image to Firebase
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Image uploaded: \(fileName)")

                // Get the download URL
                storageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                        self.paths.append(downloadURL.absoluteString)
                        completion(true)
                    } else {
                        print("Failed to retrieve download URL")
                        completion(false)
                    }
                }
            }
        }
    }

        func uploadImageToFirebase(imageURL: URL, fileName: String) {
            
            
            
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child("images/\(fileName)")

            // Ensure file exists before uploading
            guard FileManager.default.fileExists(atPath: imageURL.path) else {
                print("Error: File does not exist at path \(imageURL.path)")
                return
            }

            // Upload image file from local storage
            imageRef.putFile(from: imageURL, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }

                print("Image uploaded successfully!")

                // Get the download URL
                imageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                    } else {
                        print("Failed to retrieve download URL: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    


    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                
                self.images.append(image)
                self.collectionView.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            picker.dismiss(animated: true, completion: nil)
        }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

        
        switch type {
        case 1:
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            // Handle the selected image (e.g., display in UIImageView)
                            print("Selected image: \(selectedImage)")
                            if !(self.images.contains(selectedImage)) {
                                    self.images.append(selectedImage)
                            }
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        default:
            guard let itemProvider = results.first?.itemProvider else { return }

                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                        // Load the video and move to a permanent location
                        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                            guard let tempURL = url else { return }
                            
                            // Move the temporary video file to a permanent location
                            let permanentURL = self.copyFileToDocumentsDirectory(tempURL: tempURL)

                            DispatchQueue.main.async {
                                if let thumbnail = self.generateThumbnail(for: permanentURL) {
                                    print("Generated thumbnail: \(thumbnail)")
                                    if !(self.images.contains(thumbnail)) {
                                            self.images.append(thumbnail)
                                    }
                                    
                                    if !(self.videos.contains(permanentURL)) {
                                            self.videos.append(permanentURL)
                                    }
                                    
                                    self.collectionView.reloadData()
                                    // Use the thumbnail (e.g., display in UIImageView)
                                }
                                print("Selected video URL: \(permanentURL)")
                            }
                        }
                    }
        }
        
            
        }
    
    // Move file from temp location to permanent location in Documents directory
        func copyFileToDocumentsDirectory(tempURL: URL) -> URL {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let permanentURL = documentsDirectory.appendingPathComponent(tempURL.lastPathComponent)

            do {
                if fileManager.fileExists(atPath: permanentURL.path) {
                    try fileManager.removeItem(at: permanentURL) // Remove existing file if any
                }
                try fileManager.copyItem(at: tempURL, to: permanentURL)
                return permanentURL
            } catch {
                print("Error moving file to documents directory: \(error)")
                return tempURL // Return original temp URL if error
            }
        }

        // Generate video thumbnail
        func generateThumbnail(for url: URL) -> UIImage? {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 600) // Get thumbnail at 1 second
            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("Error generating thumbnail: \(error)")
                return nil
            }
        }
    
    
    
    @objc func removePicture(_ sender: UIButton) {
        
        
        self.images.remove(at: sender.tag)
        self.collectionView.reloadData()
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension UploadVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCVC.identifier, for: indexPath) as? MediaCVC else {
            fatalError("Unable to dequeue MediaCVC")
        }
        cell.picture.image = self.images[indexPath.row]
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(removePicture(_:)), for: .touchUpInside)
        
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            // Total horizontal spacing: (spacing between cells * (number of cells - 1)) + (left inset + right inset)
            let totalHorizontalSpacing: CGFloat = 10 * 2 // 10 is the spacing between cells, and 2 gaps for 3 cells
            let collectionViewWidth = collectionView.frame.width - totalHorizontalSpacing
            
            // Calculate the width for each cell
            let cellWidth = (collectionViewWidth - totalHorizontalSpacing) / 3
            
            // Set a fixed height for the cells
            let cellHeight: CGFloat = 100
            
            return CGSize(width: cellWidth, height: cellHeight)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // Horizontal spacing between cells
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // Vertical spacing between rows
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Section insets
        }
    
}


//MARK: API
extension UploadVC {
    
    func addContentApi(){
        self.view.aj_showDotLoadingIndicator()
        
        
        let userData = AppUserDefaults.shared.retrieveUserData()
        

        var parameters : [String: Any] = [:]
        parameters = [ContentParms.title : self.memoTitle.text!,
                          ContentParms.description :  self.memoDescription.text!,
                          ContentParms.userId : userData?.id ?? 0,
                          ContentParms.type :  self.type] as [String : Any]
        
        
        if self.selectedCategories.count > 0 {
            let ids = self.selectedCategories.map { String($0.id) }.joined(separator: ", ")
            parameters[ContentParms.categoriesId]  = ids
            
        }
        
        if self.paths.count > 0 {
            let paths = self.paths.map { String($0) }.joined(separator: ", ")
            parameters[ContentParms.paths]  = paths
            
        }
        
        
       
        
        NetworkManager.shared.call(target: Apis.addContent(params: parameters)) { (result: Result<RequestResponse<noData>, NetworkError>) in
                    
            print("Result: \(result)")
            self.view.aj_hideDotLoadingIndicator()
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    print("success message: \(response.message)")
                    self.showMessage(title: response.message, state: .success)
                    NotificationCenter.default.post(name: NSNotification.Name("refreshScreen"), object: nil)
                    self.dismissVc(UIButton())
                } else {
                    // Handle the case when success is false
                    print("failed message: \(response.message)")
                    
                    self.showMessage(title: response.message, state: .error)
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

