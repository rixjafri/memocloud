//
//  UIView+EX.swift
//  Katmeer
//
//  Created by Muhammad Nouman on 31/08/2020.
//  Copyright © 2020 Muhammad Nouman. All rights reserved.
//


#if canImport(UIKit) && !os(watchOS)
import UIKit
import Photos

// MARK: - enums
public extension UIView {

    /// SwifterSwift: Shake directions of a view.
    ///
    /// - horizontal: Shake left and right.
    /// - vertical: Shake up and down.
    enum ShakeDirection {
        /// SwifterSwift: Shake left and right.
        case horizontal

        /// SwifterSwift: Shake up and down.
        case vertical
    }

    /// SwifterSwift: Angle units.
    ///
    /// - degrees: degrees.
    /// - radians: radians.
    enum AngleUnit {
        /// SwifterSwift: degrees.
        case degrees

        /// SwifterSwift: radians.
        case radians
    }

    /// SwifterSwift: Shake animations types.
    ///
    /// - linear: linear animation.
    /// - easeIn: easeIn animation.
    /// - easeOut: easeOut animation.
    /// - easeInOut: easeInOut animation.
    enum ShakeAnimationType {
        /// SwifterSwift: linear animation.
        case linear

        /// SwifterSwift: easeIn animation.
        case easeIn

        /// SwifterSwift: easeOut animation.
        case easeOut

        /// SwifterSwift: easeInOut animation.
        case easeInOut
    }

}

// MARK: - Properties
public extension UIView {

    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// SwifterSwift: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// SwifterSwift: Take screenshot of view (if applicable).
//    var screenshot: UIImage? {
//        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
//        defer {
//            UIGraphicsEndImageContext()
//        }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        layer.render(in: context)
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }

    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// SwifterSwift: Masks to bounds of view; also inspectable from Storyboard.
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    /// SwifterSwift: x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// SwifterSwift: y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

// MARK: - Methods
public extension UIView {

    /// SwifterSwift: Recursively find the first responder.
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }

    /// SwifterSwift: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    /// SwifterSwift: Add shadow to view.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`
    func addShadow(ofColor color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.4) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func removeShadow(ofColor color: UIColor = .clear, radius: CGFloat = 0, offset: CGSize = .zero, opacity: Float = 0.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    /// SwifterSwift: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// SwifterSwift: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }

    /// SwifterSwift: Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    /// SwifterSwift: Load view of a certain type from nib
    ///
    /// - Parameters:
    ///   - withClass: UIView type.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: UIView
    class func loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }

    /// SwifterSwift: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }

    /// SwifterSwift: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    /// SwifterSwift: Attaches gesture recognizers to the view. Attaching gesture recognizers to a view defines the scope of the represented gesture, causing it to receive touches hit-tested to that view and all of its subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }

    /// SwifterSwift: Detaches gesture recognizers from the receiving view. This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }

    /// SwifterSwift: Rotate view by angle on relative axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view by.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }

    /// SwifterSwift: Rotate view to angle on fixed axis.
    ///
    /// - Parameters:
    ///   - angle: angle to rotate view to.
    ///   - type: type of the rotation angle.
    ///   - animated: set true to animate rotation (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }

    /// SwifterSwift: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }

    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }

    /// SwifterSwift: Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..)
    @available(iOS 9, *) func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }

    /// SwifterSwift: Anchor all sides of the view into it's superview.
    @available(iOS 9, *)
    func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }

    /// SwifterSwift: Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *)
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach({$0.isActive = true})

        return anchors
    }

    /// SwifterSwift: Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// SwifterSwift: Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// SwifterSwift: Anchor center X and Y into current view's superview
    @available(iOS 9, *)
    func anchorCenterSuperview() {
        // https://videos.letsbuildthatapp.com/
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }

    /// SwifterSwift: Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: predicate to evaluate on superviews.
    func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) {
            return superview
        }
        return superview?.ancestorView(where: predicate)
    }

    /// SwifterSwift: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: class of the view to search.
    func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }
}

// MARK: - Constraints
public extension UIView {
    /// SwifterSwift: Search constraints until we find one for the given view
    /// and attribute. This will enumerate ancestors since constraints are
    /// always added to the common ancestor.
    ///
    /// - Parameter attribute: the attribute to find
    /// - Parameter at: the view to find
    /// - Returns: matching constraint
    func findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
            ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.findConstraint(attribute: attribute, for: view)
    }

    /// SwifterSwift: First width constraint for this view
    var widthConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .width, for: self)
    }

    /// SwifterSwift: First height constraint for this view
    var heightConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .height, for: self)
    }

    /// SwifterSwift: First leading constraint for this view
    var leadingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .leading, for: self)
    }

    /// SwifterSwift: First trailing constraint for this view
    var trailingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .trailing, for: self)
    }

    /// SwifterSwift: First top constraint for this view
    var topConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .top, for: self)
    }

    /// SwifterSwift: First bottom constraint for this view
    var bottomConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .bottom, for: self)
    }
}

#endif
extension UIView{
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    sendSubviewToBack(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
    func roundCornerByCorner( _ corners: CACornerMask, radius: CGFloat,_ borderColor: UIColor = UIColor.clear , _ borderWidth: CGFloat = 0,shadowColor:UIColor, offset: CGSize,shadowRadius: CGFloat ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    func roundCornerByCorner( _ corners: CACornerMask, radius: CGFloat,borderColor: UIColor = UIColor.clear , borderWidth: CGFloat = 0,shadowColor:UIColor = .clear, offset: CGSize = .zero,shadowRadius: CGFloat = 0 ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    func applyTopStyle(){
        self.roundCornerByCorner(.bottomTwoCorner(), radius: 30,.clear,0, shadowColor: UIColor.black.withAlphaComponent(0.10), offset: .init(width: 0, height: 2), shadowRadius: 65)
    }
    func applyTopCornerStyle(){
        self.roundCornerByCorner(.topTwoCorner(), radius: 30,.clear,0, shadowColor: UIColor.black.withAlphaComponent(0.10), offset: .init(width: 0, height: 2), shadowRadius: 65)
    }
    func roundCornerByCorner( _ corners: CACornerMask, radius: CGFloat ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
    }
    func removeRoundCornerByCorner( _ corners: CACornerMask ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 0)
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
    }
    func circleView(){
        self.layer.cornerRadius = self.bounds.height / 2
    }
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
         let topLeftRadius = CGSize(width: topLeft, height: topLeft)
         let topRightRadius = CGSize(width: topRight, height: topRight)
         let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
         let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath()
         let shape = CAShapeLayer()
         shape.path = maskPath.cgPath
         layer.mask = shape
     }
    func applyRadiusMaskFor(topLeft: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0, topRight: CGFloat = 0) {

        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width - topRight, y: 0))
        path.addLine(to: CGPoint(x: topLeft, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: topLeft), controlPoint: .zero)
        path.addLine(to: CGPoint(x: 0, y: bounds.height - bottomLeft))
        path.addQuadCurve(to: CGPoint(x: bottomLeft, y: bounds.height), controlPoint: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width - bottomRight, y: bounds.height))
        path.addQuadCurve(to: CGPoint(x: bounds.width, y: bounds.height - bottomRight), controlPoint: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: topRight))
        path.addQuadCurve(to: CGPoint(x: bounds.width - topRight, y: 0), controlPoint: CGPoint(x: bounds.width, y: 0))

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
}
extension UIImage{
    
    func toBase64() -> String? {
        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
    
    enum JPEGQuality: CGFloat {
            case lowest  = 0
            case low     = 0.25
            case medium  = 0.5
            case high    = 0.75
            case highest = 1
        }
    
    /// Returns the data for the specified image in JPEG format.
        /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
        /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
        func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
            return jpegData(compressionQuality: jpegQuality.rawValue)
        }
    
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    struct RotationOptions: OptionSet {
            let rawValue: Int

            static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
            static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
        }

    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero

        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)

            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))

            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
            let maskImage = cgImage!

            let width = size.width
            let height = size.height
            let bounds = CGRect(x: 0, y: 0, width: width, height: height)

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

            context.clip(to: bounds, mask: maskImage)
            context.setFillColor(color.cgColor)
            context.fill(bounds)

            if let cgImage = context.makeImage() {
                let coloredImage = UIImage(cgImage: cgImage)
                return coloredImage
            } else {
                return nil
            }
        }
    
}
extension UIView {

    func setGradietColor(colorOne: UIColor, colorTwo: UIColor) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorTwo.cgColor, colorOne.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)

        layer.insertSublayer(gradientLayer, at: 0)
   }
    
}
extension UIView {
    func dropShadowN(_ shadow:CGSize,radius:CGFloat,cornerRadius:CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = shadow
        self.layer.shadowRadius = radius
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
    }
    func pushTransition(_ duration:CFTimeInterval,direction:CATransitionSubtype = .fromRight ) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .push
        animation.subtype = direction
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
}
extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
extension CACornerMask{
    static func AllCorner() -> CACornerMask{
        return [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    static func topTwoCorner() -> CACornerMask{
        return [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    static func bottomTwoCorner() -> CACornerMask{
        return [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    static func LR_BL() -> CACornerMask{
        return [.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    static func R_BRL() -> CACornerMask{
        return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
    
    static func L_BRL() -> CACornerMask{
        return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
}


@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [secondColor.withAlphaComponent(0.2),firstColor.withAlphaComponent(0.2) ].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}




extension UIButton{
    func text(_ text:String){
        self.setTitle(text, for: .normal)
    }
    var getText : String{
        return self.title(for: .normal) ?? ""
    }
    static let swizzleSendAction: Void = {
            let originalSelector = #selector(UIControl.sendAction(_:to:for:))
            let swizzledSelector = #selector(UIControl.buttonAction(_:to:for:))

            guard let originalMethod = class_getInstanceMethod(UIControl.self, originalSelector),
                  let swizzledMethod = class_getInstanceMethod(UIControl.self, swizzledSelector) else { return }

            method_exchangeImplementations(originalMethod, swizzledMethod)
        }()
        
        
}

extension UIControl {
    @objc func buttonAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if self is UIButton {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
        }
        // Call the original method (now mySendAction)
        self.buttonAction(action, to: target, for: event)
    }
}

extension PHAsset {

    func image(completionHandler: @escaping (UIImage,[AnyHashable:Any]) -> ()){
        var thumbnail = UIImage()
        var infos : [AnyHashable:Any]!
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: self, targetSize: .init(width: self.pixelWidth, height: self.pixelHeight), contentMode: .aspectFit, options: requestOptions) { img, info in
            if let image = img{
                thumbnail = image
                infos = info
            }else{
                print("Not found")
            }
        }
        completionHandler(thumbnail, infos)
     
    }
   
}



extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
