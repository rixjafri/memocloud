//
//  ApiUtility.swift
//
//  Created by MAC on 10/31/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import Alamofire

//import NVActivityIndicatorView

private let _sharedInstance = ApiUtillity()



class DCustomButton: UIButton {
    var indexpath: IndexPath?
}


class ApiUtillity: NSObject {
    
    class var sharedInstance: ApiUtillity {
        return _sharedInstance
    }
    
    // MARK:- Get App Info
    
    func getAppInfo()->String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    func getAppName()->String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        return appName
    }
    
    // MARK:- Get OS Info
    func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    // MARK:- Check Internet Connection
    func isReachable() -> Bool
    {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        return (reachabilityManager?.isReachable)!
    }
    
    // MARK:- LoaderView
    
    func showhud() {
//        let activityData = ActivityData()
//        NVActivityIndicatorView.DEFAULT_TYPE = .ballZigZagDeflect
//        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 55
//        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 55
//        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white //spinnerColor
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hidehud() {
//        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func AddSubViewtoParentView(parentview: UIView! , subview: UIView!) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
        
    }
    
    func AddSubViewtoParentViewWithRect(parentview: UIView! , subview: UIView! ,frame: CGRect){
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: frame.origin.y))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}$")
        return passwordTest.evaluate(with: password)
//        let passwordRegex =
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    func validatePhone(_ phoneNumber: String?) -> Bool {
        let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

        return phoneTest.evaluate(with: phoneNumber)
    }

    func DictToJSON(with json: [String:Any]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string! as String
    }
    
    //Date
    func ChangeDateFormate(Currentformate: String, needDateFormate: String, Date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Currentformate
        let date = dateFormatter.date(from: Date)
        dateFormatter.dateFormat = needDateFormate
        
        if let dt = date{
            return  dateFormatter.string(from: dt)
        }else{
            return ""
        }
    }
    func localToUTC(dateStr: String, currentFormate: String, getFormate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = getFormate
        
            return dateFormatter.string(from: date)
        }
        return nil
        
    }

    func utcToLocal(dateStr: String, currentFormate: String, getFormate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormate
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = getFormate
        
            return dateFormatter.string(from: localDate)
        }
        
        return nil
    }
    
    func convertUTCToLocal(formate: String, timeString: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        let timeUTC = dateFormatter.date(from: timeString)
        if timeUTC != nil {
            dateFormatter.timeZone = NSTimeZone.local
            let localTime = dateFormatter.string(from: timeUTC!)
            return localTime
        }
        
        return nil
    }

    func dateToString(date: Date, currentFormate: String, getFormate: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = currentFormate
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = getFormate
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func calcAge(birthday: String, dateFormate: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormate
        let birthdayDate = dateFormater.date(from: birthday) ?? Date()
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
        let age = calcAge.year
        return age!
    }

    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
}

