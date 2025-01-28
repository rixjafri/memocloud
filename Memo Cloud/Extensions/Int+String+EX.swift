//
//  String+EX.swift
//  karimfoodcourt
//
//  Created by Muhammad Nouman on 29/04/2021.
//

import UIKit
extension Data{
    var dataToString : String{
        return "Response:  "+(String(data: self, encoding: .utf8) ?? "")
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension String{
    
    var travelTime: String{
        
        
        if(self == "5 Minutes"){
            return "300"
        }else if(self == "15 Minutes"){
            return "900"
        }else if(self == "20 Minutes"){
            return "1200"
        }else if(self == "1 Hour"){
            return "3600"
        }else if(self == "1 Hour,30 Minutes"){
            return "5400"
        }else if(self == "2 Hour"){
            return "7200"
        }
        
        return "0"

    }
    
    var alertTime: String{
        
        
        if(self.lowercased() == "at time of event"){
            return "0"
        }else if(self.lowercased() == "5 minutes before"){
            return "1"
        }else if(self.lowercased() == "10 minutes before"){
            return "2"
        }else if(self.lowercased() == "15 minutes before"){
            return "3"
        }else if(self.lowercased() == "30 minutes before"){
            return "4"
        }else if(self.lowercased() == "1 hour before"){
            return "5"
        }else if(self.lowercased() == "2 hours before"){
            return "6"
        }else if(self.lowercased() == "1 day before"){
            return "7"
        }else if(self.lowercased() == "2 days before"){
            return "8"
        }else if(self.lowercased() == "1 week before"){
            return "9"
        }
        
        return ""

    }
    
    
    
    var correctUrl: String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    }
    var int: Int? {
        return Int(self)
    }
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    var truncateSpace : String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isValidEmail: Bool {
          // http://emailregex.com/
          let regex =
              "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
          return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    func randomAlphaNumericString(_ length: Int = 10) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    var float:Float{
        return Float(self) ?? 0.0
    }
}
extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

extension Int{
    var string:String{
        return "\(self)"
    }
    var float:Float{
        return Float(self)
    }
    func getDaysInMonth(month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from:endComps)!
        
        
        let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        
        return diff.day
    }
    func getDateFrom(month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = self
        startComps.month = month
        startComps.year = year
        
        let startDate = calendar.date(from: startComps)!
        
        return startDate
    }
}
extension Data {
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(count))
    }
    func sizeMb() -> String{
        return getSizeIn(.megabyte)
    }
    public enum DataUnits: String {
           case byte, kilobyte, megabyte, gigabyte
       }

       func getSizeIn(_ type: DataUnits)-> String {

           let data = self
           
           var size: Double = 0.0
           
           switch type {
           case .byte:
               size = Double(data.count)
           case .kilobyte:
               size = Double(data.count) / 1024
           case .megabyte:
               size = Double(data.count) / 1024 / 1024
           case .gigabyte:
               size = Double(data.count) / 1024 / 1024 / 1024
           }
           
           return String(format: "%.2f", size)
       }
}
extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        if self.isEmpty{
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: self) else {
           // preconditionFailure("Take a look to your format")
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
  
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String(($0.first ?? "U")) }).joined(separator: separator);
        return acronyms;
    }
}
extension Double {
    var string:String{
        return "\(self)"
    }
    var formatDouble:String{
        return String(format:"%.2f", self)
    }
    func round(to decimalPlaces: Int) -> Double {
        let precisionNumber = pow(10,Double(decimalPlaces))
        var n = self // self is a current value of the Double that you will round
        n = n * precisionNumber
        n.round()
        n = n / precisionNumber
        return n
    }
}
extension Bool{
    var int:Int{
        return self ? 1 : 0
    }
}
