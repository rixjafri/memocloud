//
//  UIStoryboard+EX.swift
//  CrackUp
//
//  Created by Muhammad Nouman on 26/08/2021.
//

import Foundation
import UIKit
extension UIStoryboard{
    static var Task : UIStoryboard{
        return UIStoryboard.init(name: "Task", bundle: nil)
    }
    
    static var Home : UIStoryboard{
        return UIStoryboard.init(name: "Home", bundle: nil)
    }
    
    static var Settings : UIStoryboard{
        return UIStoryboard.init(name: "PlannerSettings", bundle: nil)
    }
    
    static var Oboarding : UIStoryboard{
        return UIStoryboard.init(name: "Onboarding", bundle: nil)
    }
    
}
