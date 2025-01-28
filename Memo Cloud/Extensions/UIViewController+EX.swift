//
//  UIViewController+EX.swift
//  Logistics
//
//  Created by Muhammad Nouman on 17/12/2020.
//

import UIKit
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
}
extension UITableView{
    func registerNib(_ name:String){
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
extension UICollectionView{
    func registerNib(_ name:String){
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
