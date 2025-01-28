//
//  UIApplication+EX.swift
//  Millennium
//
//  Created by Muhammad Nouman on 10/04/2020.
//  Copyright © 2020 Nomi Malik. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication{
    
    class func getTopMostViewController(base: UIViewController? = UIApplication.KeyWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
    class func KeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }
    
}

extension UIViewController{
    static var identifier : String{
        return String(describing: self)
    }
}
