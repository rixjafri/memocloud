//
//  Enums.swift
//  JChat
//
//  Created by Darshit on 24/07/20.
//  Copyright © 2020 Darshit. All rights reserved.
//

import UIKit

//MARK: - Font Enum
enum ThemeFont: String{
    case Black = "HelveticaNeue-Black"
    case Bold = "HelveticaNeue-Bold"
    case Light = "HelveticaNeue-Light"
    case Medium = "HelveticaNeue-Medium"
    case Regular = "HelveticaNeue"

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

//MARK: - Color Enum
enum ThemeColors: String{
    case color_3563E9               = "3563E9"
    case color_F2F2F2_50524f        = "F2F2F2_50524f"
    case color_5FB345               = "5FB345"
    case color_AC242F               = "AC242F"
    case color_E89F16_20            = "E89F16_20"
    case color_E89F16               = "E89F16"
    case text_000000_FFFFFF         = "text_000000_FFFFFF"
    case background_fcfcfc_1D1E1C   = "background_fcfcfc_1D1E1C"
    case button_FFFFFF_252724       = "button_FFFFFF_252724"
    case color_CC4142               = "CC4142"
    case color_FF5253               = "FF5253"
    case color_50973A               = "50973A"
    case color_76C15E               = "76C15E"
    
    
}


//MARK: - Set Theme Color
func setColor(color: ThemeColors) -> UIColor {
    return UIColor(named: color.rawValue) ?? .blue
}

//MARK: - Animation Enum
enum Animations {
    case easeIn
    case easeOut
    case easeInOut
    case arrowUp
    case arrowDown
    case scaleIn
    case scaleOut
    case transitionIn
    case transitionOut
    case transOut
    

    func performAnimation(forView v: UIView, isShow: Bool? = true, scale: CGFloat? = 0.0, duration: TimeInterval, animated: Bool? = false) {
        switch self {
        case .easeInOut:
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                v.alpha = isShow! ? 1 : 0
                v.isHidden = isShow! ? false : true
                v.layoutIfNeeded()
            })
        case .easeIn:
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                v.alpha = isShow! ? 1 : 0
                v.isHidden = isShow! ? false : true
                v.layoutIfNeeded()
            })
        case .easeOut:
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                v.alpha = isShow! ? 1 : 0
                v.isHidden = isShow! ? false : true
                v.layoutIfNeeded()
            })
        case .arrowUp:
            UIView.animate(withDuration: (animated! ? duration : 0)) {
                v.transform = CGAffineTransform(rotationAngle: .pi)
                v.layoutIfNeeded()
            }
        case .arrowDown:
            UIView.animate(withDuration: (animated! ? duration : 0)) {
                v.transform = CGAffineTransform(rotationAngle: 0)
                v.layoutIfNeeded()
            }
        case .scaleIn:
            v.transform = CGAffineTransform(scaleX: scale!, y: scale!)
            v.alpha = 0

            UIView.animate(withDuration: duration) {
                v.transform = .identity
                v.alpha = 1
                v.layoutIfNeeded()
            }
        case .scaleOut:
            UIView.animate(withDuration: duration, animations: {
                v.transform = CGAffineTransform(scaleX: scale!, y: scale!)
                v.alpha = 0
                v.layoutIfNeeded()
            }, completion: { _ in
                v.removeFromSuperview()
            })
        case .transitionIn:
            v.alpha = 0
            UIView.animate(withDuration: duration, delay: 0, options: .transitionCrossDissolve, animations: {
                v.alpha = 1
                v.layoutIfNeeded()
            }, completion: nil)
        case .transitionOut:
            UIView.animate(withDuration: duration, delay: 0, options: .transitionCrossDissolve, animations: {
                v.alpha = 0
                v.layoutIfNeeded()
            }, completion: { _ in
                v.removeFromSuperview()
            })
        case .transOut:
            UIView.animate(withDuration: duration, delay: 0, options: .transitionCrossDissolve, animations: {
                v.alpha = 0
                v.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    static func requireUserAtencion(on onView: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: onView.center.x - 10, y: onView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: onView.center.x + 10, y: onView.center.y))
        onView.layer.add(animation, forKey: "position")
    }
}


//MARK: - SocketMessageType
enum SocketMsgType : String {
    case chat_join = "chat_join"
    case chat_leave = "chat_leave"
    case chat_message = "chat_message"
}

//enum LanguageDirection : Int {
//    case leftToRight = 1
//    case rightToLeft = 2
//}
