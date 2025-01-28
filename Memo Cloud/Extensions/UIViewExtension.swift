//
//  UIViewExtension.swift
//  Smitch Care
//
//  Created by sasikumar on 13/04/21.
//

import Foundation
import UIKit
//import Lottie

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }

    static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0
        }

    static var isJailBroken: Bool {
            get {
                if UIDevice.isSimulator { return false }
                if JailBrokenHelper.hasCydiaInstalled() { return true }
                if JailBrokenHelper.isContainsSuspiciousApps() { return true }
                if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
                return JailBrokenHelper.canEditSystemFiles()
            }
        }

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64":                                return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

@IBDesignable extension UIView {
//
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.borderColor = color.cgColor
//            } else {
//                layer.borderColor = nil
//            }
//        }
//    }
//
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowColor: UIColor? {
//        get {
//            if let color = layer.shadowColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.shadowColor = color.cgColor
//            } else {
//                layer.shadowColor = nil
//            }
//        }
//    }
    
    func createCardShape(shadowColor: UIColor = UIColor.lightGray, cornerRadius: Int = 15, showBorder: Bool = false) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.backgroundColor = .white
        if showBorder {
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 4
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }

    func threeDSetupShadow(shadowColor: UIColor = UIColor.lightGray, cornerRadius: Int = 20, showBorder: Bool = false) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 30
        self.layer.shadowOpacity = 0.2
    }
    
    func homeCardShadow(shadowColor: UIColor = setColor(color: .text_000000_FFFFFF), cornerRadius: Int = 10, showBorder: Bool = false) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1

    }
    
    func createSmallShadowShape(shadowColor: UIColor = UIColor.lightGray) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1.0
    }
    
    func createEvenCircleShadow(shadowColor: UIColor = UIColor.lightGray) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6
    }
    
    func dropShadow(color: UIColor = UIColor.lightGray) {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
//        self.backgroundColor = .white

    }
    
    func dropShadowCustomCorner(color: UIColor = UIColor.lightGray, cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.backgroundColor = .white

    }
    
    func clearShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
    }
    
    func createSmallEvenCircleShadow(shadowColor: UIColor = UIColor.lightGray) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3
    }
    
    func addEvenShadow(shadowColor: UIColor = UIColor.lightGray, cornerRadius: CGFloat = 15.0, shadowRadi: Int = 10) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = CGFloat(shadowRadi)
        self.layer.shadowOpacity = 0.5
    }
    
    func addShadow(shadowColor: UIColor = UIColor.lightGray, cornerRadius: Int = 5, shadowRadi: Int = 3, opacity: Double = 0.7) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = CGFloat(shadowRadi)
        self.layer.shadowOpacity = Float(opacity)
    }

    func addthreeDShadowWithouRadius() {
        self.layer.cornerRadius = CGFloat(10.0)
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 30
        self.layer.shadowOpacity = 0.2
    }
    func addBottomShadow() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = setColor(color: .text_000000_FFFFFF).cgColor
    }

}

extension UIView {
    func AddSubViewtoParentViewWithRect(parentview: UIView! , subview: UIView! ,frame: CGRect){
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: frame.origin.y))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
    }
    //    func addInputViewDatePicker(target: Any, selector: Selector) {
    //
    //        let screenWidth = UIScreen.main.bounds.width
    //
    //        //Add DatePicker as inputView
    //        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    //        datePicker.datePickerMode = .date
    //        self.addSubview(datePicker)
    //
    //        let calendar = Calendar(identifier: .gregorian)
    //        let currentDate = Date()
    //        var components = DateComponents()
    //        components.calendar = calendar
    //
    //        components.year = -18
    //        let maxDate = calendar.date(byAdding: components, to: currentDate)!
    //
    //        datePicker.maximumDate = maxDate
    //
    //        if #available(iOS 13.4, *) {
    //            datePicker.preferredDatePickerStyle = .wheels
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //
    //        //Add Tool Bar as input AccessoryView
    //        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    //        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    //        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    //        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
    //
    //        self.inputAccessoryView = toolBar
    //    }
    
    //    @objc func cancelPressed() {
    //        self.resignFirstResponder()
    //    }
    
    func startShimmeringViewAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne = UIColor(white: 0.90, alpha: 1.0).cgColor
        let gradientColorTwo = UIColor(white: 0.95, alpha: 1.0).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.25
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    func tapAnimate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    func add(view: UIView, left: CGFloat, right: CGFloat, top: CGFloat, height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
        view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: height).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right).isActive = true
    }
    
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        DispatchQueue.main.async { [self] in
            self.layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colorArray.map({ $0.cgColor })
            if isVertical {
                // top to bottom
                gradientLayer.locations = [0.0, 1.0]
            } else {
                // left to right
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            
            self.backgroundColor = .clear
            gradientLayer.frame = self.bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    fileprivate var lineImageView: UIImageView? {
        return lineImageView(in: self)
    }
    
    fileprivate func lineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        
        for subview in view.subviews {
            if let imageView = self.lineImageView(in: subview) { return imageView }
        }
        
        return nil
    }
    
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = setColor(color: .text_000000_FFFFFF)
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    func asImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            layer.render(in: context)
            context.restoreGState()
            guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
            UIGraphicsEndImageContext()
            return screenshot
        }
        return UIImage()
    }
    
    func asImage(with bounds: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            
            context.saveGState()
            layer.render(in: context)
            context.restoreGState()
            guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
            UIGraphicsEndImageContext()
            return screenshot
        }
        return UIImage()
    }

}
extension UIImage {
    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
    func merge(in rect: CGRect, with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        print("scale : \(UIScreen.main.scale)")
        print("size : \(size)")
        print("--------------------------------------")
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: 1)
        
        // Those multiplicators are used to properly scale the transform of each sub image as the parent image (self) might be bigger than its view bounds, same goes for the subviews
        let xMultiplicator = size.width / rect.width
        let yMultiplicator = size.height / rect.height
        
        for imageTuple in imageTuples {
            let size = CGSize(width: imageTuple.viewSize.width * xMultiplicator, height: imageTuple.viewSize.height * yMultiplicator)
            let center = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            let areaRect = CGRect(center: center, size: size)
            
            context.saveGState()
            
            let transform = imageTuple.transform
            
            context.translateBy(x: center.x, y: center.y)
            context.concatenate(transform)
            context.translateBy(x: -center.x, y: -center.y)
            
            context.setBlendMode(.color)
            UIColor.clear.withAlphaComponent(0.5).setFill()
            context.fill(areaRect)
            
            imageTuple.image.draw(in: areaRect, blendMode: .normal, alpha: 1)
            
            context.restoreGState()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
extension CGRect {
    
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        
        self.init(origin: origin, size: size)
    }
}

extension UIView {
    
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }
    
    func takeScreenshot(with scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
        return image
    }
}

enum Direction: Int {
    case topToBottom = 0
    case bottomToTop
    case leftToRight
    case rightToLeft
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
extension UINavigationBar {
    func hideBottomline() {
        self.lineImageView?.isHidden = true
    }
    
    func showBottomline() {
        self.lineImageView?.isHidden = false
    }
}

extension UIProgressView {
    @IBInspectable var barHeight: CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
            // Set the rounded edge for the outer bar
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            
            // Set the rounded edge for the inner bar
            self.layer.sublayers![1].cornerRadius = 10
            self.subviews[1].clipsToBounds = true
        }
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}

private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }

    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

func delay(durationInSeconds seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}


extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
extension UIImageView {
    func getImageFrame() -> CGRect {
        let imageSize = self.image!.size
        let imageScale = fminf(Float(self.bounds.width / imageSize.width), Float(self.bounds.height / imageSize.height))
        let scaledImageSize = CGSize(width: imageSize.width * CGFloat(imageScale), height: imageSize.height * CGFloat(imageScale))
        let imageFrame = CGRect(x: CGFloat(roundf(Float(0.5 * (self.bounds.width - scaledImageSize.width)))), y: CGFloat(roundf(Float(0.5 * (self.bounds.height - scaledImageSize.height)))), width: CGFloat(roundf(Float(scaledImageSize.width))), height: CGFloat(roundf(Float(scaledImageSize.height))))
        return imageFrame
    }
}
extension String {
    static let colorControls = "CIColorControls"
}
extension UIImage {
    var coreImage: CIImage? { return CIImage(image: self) }
}
extension CIImage {
    var uiImage: UIImage? { return UIImage(ciImage: self) }
    func applying(contrast value: NSNumber) -> CIImage? {
        return applyingFilter(.colorControls, parameters: [kCIInputContrastKey: value])
    }
    func renderedImage() -> UIImage? {
        guard let image = uiImage else { return nil }
        return UIGraphicsImageRenderer(size: image.size,
                                       format: image.imageRendererFormat).image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
}
extension UIButton {
    func setAttributedFileName() {
//        let string = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
//        string.addAttributes([.underlineStyle : NSUnderlineStyle.single.union(.patternDot).rawValue,
//                              .underlineColor : UIColor.gray.cgColor],
//                             range: NSRange(location: 0, length: string.length))
//        self.setAttributedTitle(string, for: .normal)
        
//        let text = "All of this just to underline some text? Cool."
        let bigStringFontSize: CGFloat = 25
        let smallStringFontSize: CGFloat = 14

        if let str = self.title(for: .normal) {
            let string = NSMutableAttributedString(string: str)
            let attributedText = NSMutableAttributedString(string: str)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.union(.patternDot).rawValue,
                                        range: NSRange(location: 0, length: string.length))
            
            attributedText.addAttribute(.baselineOffset,
                                        value: (bigStringFontSize - smallStringFontSize) / 2,
                                        range: NSRange(location: 0, length: string.length))

            
            attributedText.addAttribute(.underlineColor,
                                        value: setColor(color: .text_000000_FFFFFF).withAlphaComponent(0.6).cgColor,
                                        range: NSRange(location: 0, length: string.length))
            
            self.setAttributedTitle(attributedText, for: .normal)
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
