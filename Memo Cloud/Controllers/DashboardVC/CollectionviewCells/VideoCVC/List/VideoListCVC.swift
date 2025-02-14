//
//  VideoCVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 30/01/2025.
//

import UIKit
import AVFoundation

class VideoListCVC: UICollectionViewCell {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var playBtnImg: UIImageView!
    @IBOutlet var activityLoader: UIActivityIndicatorView!
    @IBOutlet var desLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: MediaInfo) {
        let imgUrl = image.path
        
        self.activityLoader.startAnimating()
        self.picture.image = nil

        if let videoURL = URL(string: imgUrl) {
            loadOrGenerateThumbnail(from: videoURL) { fileURL in
                if let savedURL = fileURL {
                    self.picture.kf.setImage(
                        with: savedURL,
                        placeholder: nil,
                        options: [.transition(.fade(0.3)), .cacheOriginalImage],
                        completionHandler: { _ in
                            self.activityLoader.stopAnimating()
                        }
                    )
                } else {
                    print("Failed to generate or load thumbnail")
                    self.activityLoader.stopAnimating()
                }
            }
        }
        
        

        
        
        
        
        
    }

    func getThumbnailPath(for videoURL: URL) -> URL {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        // Generate a unique filename using a hash of the video URL
        let filename = "\(videoURL.absoluteString.hash).jpg"
        return cachesDirectory.appendingPathComponent(filename)
    }
    
    func loadOrGenerateThumbnail(from videoURL: URL, completion: @escaping (URL?) -> Void) {
        let thumbnailURL = getThumbnailPath(for: videoURL)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: thumbnailURL.path) {
            print("Thumbnail already exists at: \(thumbnailURL)")
            completion(thumbnailURL)
        } else {
            generateThumbnail(from: videoURL, saveTo: thumbnailURL, completion: completion)
        }
    }

    func generateThumbnail(from url: URL, saveTo fileURL: URL, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            
            let time = CMTime(seconds: 1, preferredTimescale: 600) // Capture at 1 second
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                if let data = thumbnail.jpegData(compressionQuality: 1.0) {
                    do {
                        try data.write(to: fileURL)
                        DispatchQueue.main.async {
                            print("Thumbnail saved at: \(fileURL)")
                            completion(fileURL)
                        }
                    } catch {
                        print("Error saving thumbnail: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
