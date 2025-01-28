//
//  UIColor+EX.swift
//  Digital Diary
//
//  Created by Muhammad Nouman on 06/12/2021.
//

import UIKit

enum DEFAULT_COLORS:String{
    
    case color_5fb345           = "5fb345"
    case color_ac242f           = "ac242f"
    
}

extension UIColor {
    
    convenience init?(defaultColors:DEFAULT_COLORS){
        
        self.init(named: defaultColors.rawValue)
        
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
}
extension UIColor {
       /// Initialises NSColor from a hexadecimal string. Color is clear if string is invalid.
       /// - Parameter fromHex: supported formats are "#RGB", "#RGBA", "#RRGGBB", "#RRGGBBAA", with or without the # character
       public convenience init(fromHex:String) {
           var r = 0, g = 0, b = 0, a = 255
           let offset = fromHex.hasPrefix("#") ? 1 : 0
           let ch = fromHex.map{$0}
           switch(ch.count - offset) {
           case 8:
               a = 16 * (ch[offset+6].hexDigitValue ?? 0) + (ch[offset+7].hexDigitValue ?? 0)
               fallthrough
           case 6:
               r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
               g = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
               b = 16 * (ch[offset+4].hexDigitValue ?? 0) + (ch[offset+5].hexDigitValue ?? 0)
               break
           case 4:
               a = 16 * (ch[offset+3].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
               fallthrough
           case 3:  // Three digit #0D3 is the same as six digit #00DD33
               r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+0].hexDigitValue ?? 0)
               g = 16 * (ch[offset+1].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
               b = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+2].hexDigitValue ?? 0)
               break
           default:
               a = 0
               break
           }
           self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
           
       }
   }
