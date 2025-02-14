//
//  PictureCVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 30/01/2025.
//

import UIKit

class PictureGalleryCVC: UICollectionViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var activityLoader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: MediaInfo) {
        let imgUrl = image.path
        
        self.activityLoader.startAnimating()
        self.picture.image = nil

        if let url = URL(string: imgUrl) {
            // Load and cache the image using Kingfisher
            self.picture.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(0.3)), .cacheOriginalImage],
                completionHandler: { result in
                    // Stop the loader when the image has finished loading
                    self.activityLoader.stopAnimating()
                }
            )
        } else {
            // Handle invalid URL case
            self.activityLoader.stopAnimating()
            print("Invalid URL")
        }
        
        
        
        
    }

}
