//
//  Extension.swift
//  BIZE invoice
//
//  Created by Sneh Nakrani on 27/02/23.
//

import Foundation
import UIKit



extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width + 80, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.width + 800, height:width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}



extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
}

func IS_IPAD() -> Bool {
    return (UIDevice.current.userInterfaceIdiom == .pad)
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController {
    
    static func topMostViewController() -> UIViewController? {
        //        if #available(iOS 13.0, *) {
        //            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        //            return keyWindow?.rootViewController?.topMostViewController()
        //        }
        return UIWindow.key!.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
        
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
    
    func hexColor(hex:String) -> UIColor {
       var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
       
       if (cString.hasPrefix("#")) {
           cString.remove(at: cString.startIndex)
       }
       
       if ((cString.count) != 6) {
           return UIColor.gray
       }
       
       var rgbValue:UInt64 = 0
       Scanner(string: cString).scanHexInt64(&rgbValue)
       
       return UIColor(
           red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
           green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
           alpha: CGFloat(1.0)
       )
   }
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.fade
//        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    func presentDismissDetail() {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
        //        self.popVC()
    }
    
    func dismissDetail() {
//        let transition = CATransition()
//        transition.duration = 0.10
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//        self.addTransmistion(duration: 0.1)
        self.navigationController?.popViewController(animated: true)
        //        self.popVC()
    }
    
    
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    
    
    class func imageWithLabel(label: UILabel) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
            label.layer.render(in: UIGraphicsGetCurrentContext()!)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
       }
}

//MARK: API Response Status Code
extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}



extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturnded: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    colorReturnded = color
                }
            } catch {
                print("Error UserDefaults")
            }
        }
        return colorReturnded
    }
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        //  if let color = color {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
            colorData = data
        } catch {
            print("Error UserDefaults")
        }
        //  }
        set(colorData, forKey: key)
    }
}
