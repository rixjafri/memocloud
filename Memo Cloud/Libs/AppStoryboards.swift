//
//  AppStoryboards.swift
//  EyecareBrands
//
//  Created by Naveed ur Rehman on 26/08/2022.
//
import UIKit

extension UIStoryboard {
    
    //MARK:- Generic Public/Instance Methods
    
    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
    
    //MARK:- Class Methods to load Storyboards
    
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
}

enum storyboards : String {
    case auth                       = "Auth",
         main                       = "Main",
         permissions                = "Permissions",
         settings                   = "Settings",
         inventory                  = "Inventory",
         sales                      = "Sales",
         mukechi                    = "Mukechi",
         dashboard                  = "Dashboard",
         filters                    = "Filters",
         saleReport                 = "saleReport",
         bankTransfer               = "bankTransfer",
         purchaseReport             = "purchaseReport"
    
    
}

enum viewControllers: String {
    
    //Main Storyboard
    case loginVC                    = "LoginVC"
    case forgotVC                   = "ForgotVC"
    case verificationVC             = "VerificationVC"
    case passwordVC                 = "PasswordVC"
    case passwordChangeVC                 = "PasswordChangeVC"
    case dashboardVC                = "DashboardVC"
    case notificationVC             = "NotificationVC"
    case notificationPermissionVC   = "NotificationPermissionVC"
    case settingsVC                 = "SettingsVC"
    case appearanceVC               = "AppearanceVC"
    case vehiclesVC                 = "VehiclesVC"
    case favoritesVC                = "FavoritesVC"
    case saleReportVC               = "SaleReportVC"
    case purchaseReportVC           = "PurchaseReportVC"
    case mukechiVC                  = "MukechiVC"
    case salesVC                    = "SalesVC"
    case filterVC                   = "FilterVC"
    case listVC                     = "ListVC"
    case dateVC                     = "DateVC"
    case previewVC                  = "PreviewVC"
    case galleryVC                  = "GalleryVC"
    case bankTransferReportVC       = "BankTransferReportVC"
    case bankReportVC               = "BankReportVC"
    
    
}
