//
//  PicturesDetailVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 02/12/2024.
//

import UIKit
import ImageViewer_swift
import SDWebImage
import DropDown

class PicturesDetailVC: BaseVC {

    
    
    @IBOutlet weak var collectionView : UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.registerNib(PhotoCVC.identifier)
        }
    }
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var norecord: UIView!
    @IBOutlet var screenTitle: UILabel!
    
    @IBOutlet var menuView: UIView!
    
    
    let menuArr = ["Edit","Delete"]
    var imageUrls : [URL] = []
    var downloadedImageUrls : [URL] = []
    var subTitle : String?
    var userId : Int?
    var mediaInfo : [MediaInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.menuView.isHidden = true
        if let userData = AppUserDefaults.shared.retrieveUserData(){
            self.menuView.isHidden = userData.id == self.userId ? false:true
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        self.screenTitle.text = self.subTitle?.capitalized
        
        if self.mediaInfo.count > 0 {
            self.norecord.isHidden = true
            self.imageUrls = mediaInfo.compactMap { URL(string: $0.path) }
            self.collectionView.reloadData()
        }else{
            self.norecord.isHidden = false
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func dismissVc(_ sender: Any) {
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.vibrate()
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = menuView // UIView or UIBarButtonItem
//        dropDown.width = menuView.bounds.width - 20
        dropDown.direction = .bottom
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = menuArr
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectRow(at: 0)
        
        
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          
            
            
        }
        dropDown.backgroundColor = .white
        dropDown.selectedTextColor = .black
        dropDown.selectionBackgroundColor = .white
        dropDown.dimmedBackgroundColor = .clear
        dropDown.cornerRadius = 10
        dropDown.show()
        
    }
    
    
    

}


extension PicturesDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mediaInfo.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as? PhotoCVC else {fatalError()}
            let img = self.mediaInfo[indexPath.row]
            cell.configure(image: img)
            
            cell.picture.setupImageViewer(
                urls: self.imageUrls,
                initialIndex: indexPath.item,
                options: [
                    .theme(.dark),
                    .rightNavItemTitle("", onTap: { i in
                        
                        self.dismiss(animated: true)
                        
                    })
                ],
                from: self)
            /*
             
             let imageUrl = self.imageUrls[i]
             self.shareImage(imageUrl: imageUrl)
             */
            return cell
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Add spacing to all sides
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = (numberOfColumns - 1) * spacing + 20 // Account for left and right insets
        let itemWidth = (collectionView.frame.width - totalSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    
}


