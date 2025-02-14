//
//  DashboardVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 28/01/2025.
//

import UIKit
import PinterestLayout
import SwiftQRCodeScanner
import DropDown

class DashboardVC: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView! {
            didSet {
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.contentInsetAdjustmentBehavior = .never
                
                collectionView.registerNib(PictureGalleryCVC.identifier)
                collectionView.registerNib(PictureListCVC.identifier)
                collectionView.registerNib(PictureCVC.identifier)
                
                collectionView.registerNib(VideoGalleryCVC.identifier)
                collectionView.registerNib(VideoListCVC.identifier)
                collectionView.registerNib(VideoCVC.identifier)
                
                collectionView.registerNib(TextGalleryCVC.identifier)
                collectionView.registerNib(TextListCVC.identifier)
                collectionView.registerNib(TextCVC.identifier)
                
                
                
            }
        }
    
    
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
            didSet {
                categoryCollectionView.delegate = self
                categoryCollectionView.dataSource = self
                categoryCollectionView.contentInsetAdjustmentBehavior = .never
                categoryCollectionView.registerNib(CategoryCVC.identifier)
                
            }
        }
    
    
    @IBOutlet var norecord: UIView!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var dashboardTitle: UILabel!
    @IBOutlet var filterView: UIView!
    
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchViewWidth: NSLayoutConstraint!
    var isSearchEnabled: Bool = false
    
    var contentType: ListType = .gallry
    let contentTypeArr = ["Gallery","List", "Text"]
    var contentArr : [Contents] = []
    
    var selectedCategories : [Categories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(scannerOpen), name: NSNotification.Name("scannerOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: NSNotification.Name("refreshScreen"), object: nil)
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.estimatedItemSize = .zero
//        }
        self.searchField.isHidden = !self.isSearchEnabled
        self.searchField.delegate = self
        self.getCategoryApi()
        self.layoutAdjustment()
        self.getContentApi()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
        
    
    deinit {
        print("ViewController Deallocated")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("scannerOpen"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("refreshScreen"), object: nil)
        
    }
    
    @objc func handleNotification(_ notification: Notification) {
        // Handle the notification
        print("Notification received!")
    }
    
    func layoutAdjustment(){
        
        let layout = PinterestLayout()
                layout.delegate = self
        layout.numberOfColumns = contentType == .list || contentType == .text ? 1:2
                layout.cellPadding = 8  // Padding between cells

                collectionView.collectionViewLayout = layout
    }

    
    @IBAction func settingsAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .settingsVC) as! SettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func addMenuTapped(_ sender: UIButton) {
        SceneDelegate.sharedInstance.openMenu()
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = filterView // UIView or UIBarButtonItem
        dropDown.direction = .bottom
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = contentTypeArr
        dropDown.width = 100
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectRow(at: 0)
        
        
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          
            switch index {
            case 0:
                contentType = .gallry
            case 1:
                contentType = .list
            default:
                contentType = .text
            }
            
            
            
            self.layoutAdjustment()
            self.collectionView.reloadData()
            
        }
        dropDown.backgroundColor = .white
        dropDown.selectedTextColor = .black
        dropDown.selectionBackgroundColor = .white
        dropDown.dimmedBackgroundColor = .clear
        dropDown.cornerRadius = 10
        dropDown.show()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.searchField.text == "" {
            UIView.animate(withDuration: 0.3, animations: {
                
                let width = self.isSearchEnabled == false ? self.view.frame.width * 0.86 : 40
                
                self.searchViewWidth.constant = width
                self.view.layoutIfNeeded()
                
                
                if self.isSearchEnabled {
                    self.view.aj_showDotLoadingIndicator()
                    self.getContentApi()
                }else{
                    self.searchField.becomeFirstResponder()
                }
                
                
            }, completion: { finished in
                if finished {
                    // Code to execute after the animation completes
                    self.isSearchEnabled = !self.isSearchEnabled
                    
                    self.searchField.isHidden = !self.isSearchEnabled
                    
                }
            })
        }else{
            
            
            
            
            self.view.aj_showDotLoadingIndicator()
            self.getContentApi()
            
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchAction(self.searchBtn)
        
        
            return true // Indicates that the text field should process the return button press
        }
}

// MARK: - UICollectionViewDataSource
extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return collectionView == self.categoryCollectionView ? self.categories.count:self.contentArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVC.identifier, for: indexPath) as? CategoryCVC else {
                fatalError("Unable to dequeue CategoryCVC")
            }
            let category = self.categories[indexPath.row]
            cell.categoryLbl.text = category.name
            
            if (selectedCategories.firstIndex(where: { $0.id == category.id }) != nil) {
                // Category exists, remove it
                cell.mainView.backgroundColor = setColor(color: .color_3563E9)
            } else {
                // Category does not exist, add it
                cell.mainView.backgroundColor = .white
                
            }
            
                
                
                
            // Configure the cell if needed
            return cell
        }
        
        let content = self.contentArr[indexPath.row]
        
        if contentType == .gallry {
            switch content.type {
            case 0:
                // Dequeue TextCVC for indices 0, 3, 6, 9, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextGalleryCVC.identifier, for: indexPath) as? TextGalleryCVC else {
                    fatalError("Unable to dequeue TextCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.descriptionLbl.text = content.description
                cell.categoryLbl.text = content.categoriesNames
                return cell
            case 1:
                // Dequeue PictureCVC for indices 1, 4, 7, 10, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureGalleryCVC.identifier, for: indexPath) as? PictureGalleryCVC else {
                    fatalError("Unable to dequeue PictureCVC")
                }
                
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                let media = content.mediaInfo ?? []
                if media.count > 0 {
                    cell.configure(image: media.first!)
                }
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                // Configure the cell if needed
                return cell
            case 2:
                // Dequeue VideoCVC for indices 2, 5, 8, 11, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoGalleryCVC.identifier, for: indexPath) as? VideoGalleryCVC else {
                    fatalError("Unable to dequeue VideoCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                let media = content.mediaInfo ?? []
                if media.count > 0 {
                    cell.configure(image: media.first!)
                }
                return cell
            default:
                fatalError("Unexpected index")
            }
        } else if contentType == .list {
            switch content.type {
            case 0:
                // Dequeue TextCVC for indices 0, 3, 6, 9, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextListCVC.identifier, for: indexPath) as? TextListCVC else {
                    fatalError("Unable to dequeue TextCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title
                cell.descriptionLbl.text = content.description
                cell.categoryLbl.text = content.categoriesNames
                return cell
            case 1:
                // Dequeue PictureCVC for indices 1, 4, 7, 10, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureListCVC.identifier, for: indexPath) as? PictureListCVC else {
                    fatalError("Unable to dequeue PictureCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                cell.desLbl.text = content.description
                let media = content.mediaInfo ?? []
                if media.count > 0 {
                    cell.configure(image: media.first!)
                }
                return cell
            case 2:
                // Dequeue VideoCVC for indices 2, 5, 8, 11, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoListCVC.identifier, for: indexPath) as? VideoListCVC else {
                    fatalError("Unable to dequeue VideoCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                cell.desLbl.text = content.description
                let media = content.mediaInfo ?? []
                if media.count > 0 {
                    cell.configure(image: media.first!)
                }
                return cell
            default:
                fatalError("Unexpected index")
            }
            
            
            
        } else if contentType == .text {
            switch content.type {
            case 0:
                // Dequeue TextCVC for indices 0, 3, 6, 9, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCVC.identifier, for: indexPath) as? TextCVC else {
                    fatalError("Unable to dequeue TextCVC")
                }
                
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.descriptionLbl.text = content.description
                cell.categoryLbl.text = content.categoriesNames
                return cell
            case 1:
                // Dequeue PictureCVC for indices 1, 4, 7, 10, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCVC.identifier, for: indexPath) as? PictureCVC else {
                    fatalError("Unable to dequeue PictureCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.desLbl.text = content.description
                cell.categoryLbl.text = content.categoriesNames
                
                return cell
            case 2:
                // Dequeue VideoCVC for indices 2, 5, 8, 11, etc.
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCVC.identifier, for: indexPath) as? VideoCVC else {
                    fatalError("Unable to dequeue VideoCVC")
                }
                // Configure the cell if needed
                cell.titleLbl.text = content.title.capitalized
                cell.categoryLbl.text = content.categoriesNames
                cell.desLbl.text = content.description
                cell.categoryLbl.text = content.categoriesNames
                return cell
            default:
                fatalError("Unexpected index")
            }
            
            
            
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.vibrate()
        
        
        if collectionView == self.collectionView {
            let content = self.contentArr[indexPath.row]
            
            switch content.type {
            case 0:
                let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .notesDetailVC) as! NotesDetailVC
                vc.subTitle = content.title
                vc.content = content
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .picturesDetailVC) as! PicturesDetailVC
                vc.subTitle = content.title
                vc.content = content
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                if let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .previewVC) as? PreviewVC {
                    vc.titleName = content.title
                    vc.url = content.mediaInfo?.first?.path ?? ""
                    vc.modalPresentationStyle = .formSheet
                    self.present(vc, animated: true)
                }
            }
        }else{
            let category = self.categories[indexPath.row]
            if let index = selectedCategories.firstIndex(where: { $0.id == category.id }) {
                // Category exists, remove it
                self.selectedCategories.remove(at: index)
            } else {
                // Category does not exist, add it
                self.selectedCategories.append(category)
            }
            
            self.categoryCollectionView.reloadData()
            self.getContentApi()
        }
        
        
        
        
        
    }
    
    
    
    
}

extension DashboardVC: PinterestLayoutDelegate {
    
    // ✅ Correct method for image height
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        
        let content = self.contentArr[indexPath.row]
        
        if contentType == .gallry {
            switch content.type {
                case 0:
                    // TextCVC: Set a smaller height range
                    return 150
                case 1:
                    // PictureCVC: Set a medium height range
                    return 200
                case 2:
                    // VideoCVC: Set a larger height range
                    return 250
                default:
                    // Default range for unexpected cases
                    return 300
                }
        }else if contentType == .list {
            return 100
        }
            
        return 100
    }
    
    
    
    
    // ✅ Correct method for text annotation height
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let content = self.contentArr[indexPath.row]
        let text = content.description
        let font = UIFont(name: "HelveticaNeue", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        
        return text.heightForWidth(width: width, font: font)
    }
}


extension DashboardVC: QRScannerCodeDelegate {
    
    @objc func scannerOpen() {
        // Perform any updates needed after scanner is dismissed
        
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    @objc func refreshScreen() {
        
        // Perform any updates needed after scanner is dismissed
        
        self.getContentApi()
    }
    
   
    // QRScannerCodeDelegate method
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
            print("Scanned QR Code: \(result)")
            controller.dismiss(animated: true, completion: nil)
        }

        func qrScannerDidFail(_ controller: UIViewController, error: String) {
            print("Failed: \(error)")
            controller.dismiss(animated: true, completion: nil)
        }

        func qrScannerDidCancel(_ controller: UIViewController) {
            print("QR Scanner Canceled")
            controller.dismiss(animated: true, completion: nil)
        }
    
    
    func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
        print("QR Scanner failed: \(error)")
    }

}


extension DashboardVC {
    
    func getContentApi(){
        self.view.aj_showDotLoadingIndicator()
        
        var parameters = [ContentParms.search : self.searchField.text ?? ""] as [String : Any]
        
        if self.selectedCategories.count > 0 {
            let ids = self.selectedCategories.map { String($0.id) }.joined(separator: ", ")
            parameters[ContentParms.categoriesId]  = ids
            
        }
        print(parameters)
        
        NetworkManager.shared.call(target: Apis.getContent(params: parameters)) { (result: Result<RequestResponse<[Contents]>, NetworkError>) in
                    
            print("Result: \(result)")
            self.view.aj_hideDotLoadingIndicator()
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    if let contents = response.data {
                        print("User Data: \(contents)")
                        
                        self.contentArr = contents
                        self.norecord.isHidden = self.contentArr.count > 0 ? true : false
                        self.collectionView.reloadData()
                        
                        
                        
                    } else {
                        print("No user data available.")
                        self.showMessage(title: "No user data available.", state: .error)
                    }
                    
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
    
    func getCategoryApi(){
        
        
        
        
        
        NetworkManager.shared.call(target: Apis.getCategories) { (result: Result<RequestResponse<[Categories]>, NetworkError>) in
                    
            print("Result: \(result)")
            
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    if let categoriesArr = response.data {
                        print("User Data: \(categoriesArr)")
                        
                        self.categories = categoriesArr
                        AppUserDefaults.shared.saveCategoriesData(categories: self.categories)
                        self.categoryCollectionView.reloadData()
                        
                        
                        
                    } else {
                        print("No user data available.")
                        self.showMessage(title: "No user data available.", state: .error)
                    }
                    
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




