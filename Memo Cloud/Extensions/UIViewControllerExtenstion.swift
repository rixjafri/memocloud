//
//  UIViewControllerExtenstion.swift
//  Smitch Care
//
//  Created by sasikumar on 13/04/21.
//

import Foundation
import UIKit
import Network
import CoreBluetooth
import SafariServices

extension UIViewController {
    
    func showAlert3Buttons(deleteAction: ((UIAlertAction) -> Void)? = nil, retakeAction: ((UIAlertAction) -> Void)? = nil) {
        let message = "This will permanently delete and cannot be undone."
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: "Delete this page?", message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteAction)
        
        let retakeAction = UIAlertAction(title: "Retake", style: .default, handler: retakeAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            UIAlertAction in
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(retakeAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func showAlert2Buttons(yesAction: ((UIAlertAction) -> Void)? = nil) {
        let message = "Are you sure you want to add this signature into your pdf?"
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: "Scandex", message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let retakeAction = UIAlertAction(title: "Yes", style: .default, handler: yesAction)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(retakeAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert1Buttons(msg: String) {
        
        let attributedString = NSAttributedString(string: msg, attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: "Scandex", message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func showAlertDeleteConfirmation(title: String, msg: String, yesAction: ((UIAlertAction) -> Void)? = nil) {
        
        let attributedString = NSAttributedString(string: msg, attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Delete", style: .destructive, handler: yesAction)
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertConfirmationButtons(backAction: ((UIAlertAction) -> Void)? = nil) {
        
        let attributedString = NSAttributedString(string: "Do you really want to go back to the app?", attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: "Scandex", message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let backAction = UIAlertAction(title: "Back", style: .default, handler: backAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(backAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertConfirmationButtons(message: String, btnTitle: String, backAction: ((UIAlertAction) -> Void)? = nil) {
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : ThemeFont.Regular.of(size: 14), //your font here
            NSAttributedString.Key.foregroundColor : setColor(color: .text_000000_FFFFFF)
        ])
        
        let alertController = UIAlertController(title: "JJSystem", message: "", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let backAction = UIAlertAction(title: btnTitle, style: .destructive, handler: backAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(backAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func setTitleToBar(title: String, isLargeDisplayEnable: Bool) {
        if isLargeDisplayEnable {
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationController?.navigationBar.prefersLargeTitles = isLargeDisplayEnable
        self.navigationItem.title = title
    }
    
    func addBackButton() {
        let customBack = UIBarButtonItem(image: UIImage.init(systemName: "ic_Arrow_back"), style: .done, target: self, action: #selector(backButtonClick))
        //        customBack.tintColor = setColor(color: .ColorWight)
        self.navigationItem.leftBarButtonItem = customBack
    }
    
    @objc func backButtonClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setStoryBoard(name: StoryBoard) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
    func pushVC(vc: UIViewController, animation: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    func setVC(vc: UIViewController, animation: Bool = true) {
        self.navigationController?.setViewControllers([vc], animated: animation)
    }
    func addTransmistion(duration: CGFloat = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
    }
    
    
}
extension UICollectionView {
    func currentIndex() -> IndexPath {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else { return IndexPath(row: 0, section: 0) }
        return indexPath
    }
}

enum StoryBoard: String {
    case Main = "Main"
    case TabBar = "ScandexTabBar"
    case Settings = "ScandexSettings"
    case Tools = "Tools"
    case Scan = "Scan"
    case CustomScanner = "CustomScanner"
    case Markup = "Markup"
    case SavedDocument = "SavedDocument"
    case WaterMark = "WaterMark"
    case IDCard = "IDCard"
}

//extension UIImage {
//    func rotate(radians: CGFloat) -> UIImage {
//        let rotatedSize = CGRect(origin: .zero, size: size)
//            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
//            .integral.size
//        UIGraphicsBeginImageContext(rotatedSize)
//        if let context = UIGraphicsGetCurrentContext() {
//            let origin = CGPoint(x: rotatedSize.width / 2.0,
//                                 y: rotatedSize.height / 2.0)
//            context.translateBy(x: origin.x, y: origin.y)
//            context.rotate(by: radians)
//            draw(in: CGRect(x: -origin.y, y: -origin.x,
//                            width: size.width, height: size.height))
//            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            return rotatedImage ?? self
//        }
//
//        return self
//    }
//    func rotate(style: RotateView) -> UIImage {
//        switch style {
//        case .right:
//            var imageToDisplay: UIImage? = nil
//            if let cgImage = self.cgImage {
//                imageToDisplay = UIImage(
//                    cgImage: cgImage,
//                    scale: self.scale,
//                    orientation: .right)
//            }
//            if let img = imageToDisplay {
//                return img
//            }
//        case .left:
//            var imageToDisplay: UIImage? = nil
//            if let cgImage = self.cgImage {
//                imageToDisplay = UIImage(
//                    cgImage: cgImage,
//                    scale: self.scale,
//                    orientation: .left)
//            }
//            if let img = imageToDisplay {
//                return img
//            }
//        case .down:
//            var imageToDisplay: UIImage? = nil
//            if let cgImage = self.cgImage {
//                imageToDisplay = UIImage(
//                    cgImage: cgImage,
//                    scale: self.scale,
//                    orientation: .down)
//            }
//            if let img = imageToDisplay {
//                return img
//            }        case .up:
//            var imageToDisplay: UIImage? = nil
//            if let cgImage = self.cgImage {
//                imageToDisplay = UIImage(
//                    cgImage: cgImage,
//                    scale: self.scale,
//                    orientation: .up)
//            }
//            if let img = imageToDisplay {
//                return img
//            }
//        default:
//            break
//        }
//        return UIImage()
//
//    }
//}
@IBDesignable
class DynamicImageView: UIImageView {

    @IBInspectable var fixedWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable var fixedHeight: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = CGSize.zero
        if fixedWidth > 0 && fixedHeight > 0 { // 宽高固定
            size.width = fixedWidth
            size.height = fixedHeight
        } else if fixedWidth <= 0 && fixedHeight > 0 { // 固定高度动态宽度
            size.height = fixedHeight
            if let image = self.image {
                let ratio = fixedHeight / image.size.height
                size.width = image.size.width * ratio
            }
        } else if fixedWidth > 0 && fixedHeight <= 0 { // 固定宽度动态高度
            size.width = fixedWidth
            if let image = self.image {
                let ratio = fixedWidth / image.size.width
                size.height = image.size.height * ratio
            }
        } else { // 动态宽高
            size = image?.size ?? .zero
        }
        return size
    }

}
class AdjustableImageView: UIImageView {

    /// `NSLayoutConstraint` constraining `heightAnchor` relative to the `widthAnchor`
    /// with the same `multiplier` as the inverse of the `image` aspect ratio, where aspect
    /// ratio is defined width/height.
    private var aspectRatioConstraint: NSLayoutConstraint?

    /// Override `image` setting constraint if necessary on set
    override var image: UIImage? {
        didSet {
            updateAspectRatioConstraint()
        }
    }

    // MARK: - Init

    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    /// Shared initializer code
    private func setup() {
        // Set default `contentMode`
        contentMode = .scaleAspectFill

        // Update constraints
        updateAspectRatioConstraint()
    }

    // MARK: - Resize

    /// De-active `aspectRatioConstraint` and re-active if conditions are met
    private func updateAspectRatioConstraint() {
        // De-active old constraint
        aspectRatioConstraint?.isActive = false

        // Check that we have an image
        guard let image = image else { return }

        // `image` dimensions
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        // `image` aspectRatio
        guard imageWidth > 0 else { return }
        let aspectRatio = imageHeight / imageWidth
        guard aspectRatio > 0 else { return }

        // Create a new constraint
        aspectRatioConstraint = heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: aspectRatio
        )

        // Activate new constraint
        aspectRatioConstraint?.isActive = true
    }
}

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
extension UIViewController{
    func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.tintColor = setColor(color: .text_000000_FFFFFF)
        loadingIndicator.startAnimating();
        
        ProgressDialog.alert.view.addSubview(loadingIndicator)
        present(ProgressDialog.alert, animated: false, completion: nil)
    }
    
    func LoadingStop(){
        ProgressDialog.alert.dismiss(animated: false, completion: nil)
    }
  

}
extension UIImageView {
    func getMergedImage(stickerView: UIImageView, frame: CGRect, frame1: CGRect) -> UIImage {
        if (self.image == nil) {
            return stickerView.image!
        }
        
        let top = (frame1.origin.y - frame.origin.y)//(frame.origin.y + frame.height) - frame1.origin.y
        let center = (frame1.origin.x - frame.origin.x)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), self.isOpaque, 0)
        
        self.image?.draw(in: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        stickerView.image?.draw(in: CGRect.init(x: center, y: top, width: frame1.width, height: frame1.height))//.insetBy(dx: 50 * 0.2, dy: 50 * 0.2))
        //    }
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func getMergedLabel(stickerView: UILabel, frame: CGRect, frame1: CGRect) -> UIImage {
        if (self.image == nil) {
            return UIImage()
        }
        
        let top = (frame1.origin.y - frame.origin.y)//(frame.origin.y + frame.height) - frame1.origin.y
        let center = (frame1.origin.x - frame.origin.x)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), self.isOpaque, 0)
        
        self.image?.draw(in: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        stickerView.drawText(in: CGRect.init(x: center, y: top, width: frame1.width, height: frame1.height))//.insetBy(dx: 50 * 0.2, dy: 50 * 0.2))
        //    }
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

func boldSearchResult(searchString: String, resultString: String) -> NSMutableAttributedString {
    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: resultString)
    let pattern = searchString.lowercased()
    let range: NSRange = NSMakeRange(0, resultString.count)

    let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())

    regex.enumerateMatches(in: resultString.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) { (textCheckingResult, matchingFlags, stop) -> Void in
        let subRange = textCheckingResult?.range
        attributedString.addAttribute(NSAttributedString.Key.font, value: ThemeFont.Bold.of(size: 14.0), range: subRange!)
    }
    return attributedString
}
extension UIImage {
    func imageBlackAndWhite() -> UIImage {
        guard let currentCGImage = self.cgImage else { return self }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(1.8, forKey: "inputContrast")
        filter?.setValue(0.3, forKey: "inputBrightness")
//        filter?.setValue(1.3, forKey: "inputSaturation")

//        filter?.setValue(1, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return UIImage() }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
//        return self.setFilterImage(Img: currentCIImage, filterName: "CIDocumentEnhancer")
        return self
    }
}
extension URL {
    func drawPDFfromURL() -> UIImage? {
            guard let document = CGPDFDocument(self as CFURL) else { return nil }

            var width: CGFloat = 0
            var height: CGFloat = 0
            
            // calculating overall page size
            for index in 1...document.numberOfPages {
                print("index: \(index)")
                if let page = document.page(at: index) {
                    let pageRect = page.getBoxRect(.mediaBox)
                    width = max(width, pageRect.width)
                    height = height + pageRect.height
                }
            }

            // now creating the image
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

            let image = renderer.image { (ctx) in
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                for index in 1...document.numberOfPages {
                    
                    if let page = document.page(at: index) {
                        let pageRect = page.getBoxRect(.mediaBox)
                        ctx.cgContext.translateBy(x: 0.0, y: -pageRect.height)
                        ctx.cgContext.drawPDFPage(page)
                    }
                }
                
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            }
            return image
        }
}
extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
            if data.count < sizeInBytes {
                needCompress = false
                imgData = data
            } else {
                compressingValue -= 0.1
            }
        }
    }

    if let data = imgData {
        if (data.count < sizeInBytes) {
            return UIImage(data: data)
        }
    }
        return nil
    }
}
