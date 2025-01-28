//
//  FloatingView.swift
//  FloatingView
//
//  Created by Ali Pourhadi on 2017-05-07.
//  Copyright © 2017 Ali Pourhadi. All rights reserved.
//

import Foundation
import UIKit

public protocol FloatingViewDelegate {
    func viewDraggingDidBegin(view:UIView, in window:UIWindow?)
    func viewDraggingDidEnd(view:UIView, in window:UIWindow?)
}

class FloatingWindow : UIWindow {
    public var topView : UIView = UIView()
    lazy var pointInsideCalled : Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            self.pointInsideCalled = true
            return topView
        }
        if pointInsideCalled {
            self.pointInsideCalled = false
            return topView
        }
        return nil
    }
}

public class FloatingView {
    
     var floatingWindow: FloatingWindow?
    public var appWindow:UIWindow?
    public var floatingView:UIView!
    
    public var isShowing = false
    public var delegate:FloatingViewDelegate?
    
    public init(with view:UIView , layer:CGFloat = 1) {
        
        self.floatingView = view
        self.appWindow = UIWindow.key!
        self.floatingWindow = FloatingWindow(frame: view.frame)
        print("FRAME : ", view.frame)
        self.floatingWindow?.topView = view
        self.floatingWindow?.rootViewController?.view = view
        self.floatingWindow?.windowLevel = UIWindow.Level(layer)
        self.floatingWindow?.makeKeyAndVisible()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
    }
        
    public func show() {
        
        if self.isShowing { return }
        self.isShowing = true
        floatingWindow?.isHidden = false
        UIWindow.key!.addSubview(self.floatingView)
        delay(durationInSeconds: 10.0) {
            UIView.animate(withDuration: 0.3) {
                self.floatingView.alpha = 0.4
            }
        }
    }
    
    public func hide() {
        
        self.isShowing = false
        floatingWindow?.isHidden = true
//        UIWindow.key?.willRemoveSubview(self.floatingView)
        self.floatingView.removeFromSuperview()
        
    }

    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {

        let translation = panGesture.translation(in: floatingWindow)

        floatingView?.frame.origin.x += translation.x
        floatingView?.frame.origin.y += translation.y

        if panGesture.state == .began {
            delegate?.viewDraggingDidBegin(view: floatingView, in: appWindow)
        }

        if panGesture.state == .ended {
            print("<------------------------")
            print("TRANSLATION X :", translation.x)
            print("TRANSLATION Y :", translation.y)
            print("SCREEN-WIDTH  :", UIScreen.main.bounds.width)
            print("SCREEN-HEIGHT :", UIScreen.main.bounds.height)
            print("F-WINDOW X    :", floatingView?.frame.origin.x ?? 1)
            print("F-WINDOW Y    :", floatingView?.frame.origin.y ?? 1)
            print("BOUNDS.SIZE   :", floatingView?.frame.size ?? CGSize(width: 70, height: 70))
            print("CENTER        :", floatingView?.center ?? CGPoint(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.minY))
            print("------------------------>")

            
            if floatingView.frame.origin.y <= 50  {
                if ((floatingView?.center.x ?? UIScreen.main.bounds.minX) + translation.x) >= (UIScreen.main.bounds.width / 2) {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((UIScreen.main.bounds.width) - ((self.floatingView?.frame.size.width ?? 70) / 2)), y: 60)
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((self.floatingView?.frame.size.width ?? 70) / 2), y: 60)
                    }
                }
            } else if floatingView.frame.origin.y >= (UIScreen.main.bounds.height - 100) {
                if ((floatingView?.center.x ?? UIScreen.main.bounds.minX) + translation.x) >= (UIScreen.main.bounds.width / 2) {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((UIScreen.main.bounds.width) - ((self.floatingView?.frame.size.width ?? 70) / 2)), y: UIScreen.main.bounds.height - 50)
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((self.floatingView?.frame.size.width ?? 70) / 2), y: UIScreen.main.bounds.height - 50)
                    }
                }
            } else {
                if ((floatingView?.center.x ?? UIScreen.main.bounds.minX) + translation.x) >= (UIScreen.main.bounds.width / 2) {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((UIScreen.main.bounds.width) - ((self.floatingView?.frame.size.width ?? 70) / 2)), y: (self.floatingView?.center.y ?? UIScreen.main.bounds.minY + translation.y))
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.floatingView?.center = CGPoint(x: ((self.floatingView?.frame.size.width ?? 70) / 2), y: (self.floatingView?.center.y ?? UIScreen.main.bounds.minY + translation.y))
                    }
                }
            }
            
            
            delegate?.viewDraggingDidEnd(view: floatingView, in: appWindow)

        }
        
        panGesture.setTranslation(.zero, in: floatingWindow)
    }
    
    // Handleing movement of view
//    private func viewDidMove(to location:CGPoint) {
//        let point = (self.floatingWindow?.convert(location, to: self.appWindow))!
//        print("∞∞∞", point)
//        self.floatingWindow?.center = point
//        UIView.commitAnimations()
//    }
    
    func judgeLocationIsLeft() -> Bool {
        let middleX = (UIScreen.main).bounds.size.width / 2.0
        let curX = (self.floatingWindow?.frame.origin.x ?? 10) + (self.floatingWindow?.bounds.size.width ?? 10)/2
        
        if curX <= middleX {
            return true
        } else {
            return false
        } 
    }
    
    func moveTohalfInScreenWhenScrolling(){
        let isLeft = self.judgeLocationIsLeft()
        self.moveStayToMiddleInScreenBorder(isLeft)
    }
    
    func moveStayToMiddleInScreenBorder(_ isLEFT : Bool){
//        var frame = self.floatingWindow!.frame
        let stayWidth = self.floatingWindow!.frame.size.width
        var destinationX = 0.0
        
        if isLEFT {
            destinationX -= stayWidth/2
        } else {
            destinationX = (UIScreen.main.bounds.size.width) - (stayWidth) + (stayWidth/2);
        }
        self.floatingWindow!.frame.origin.x = destinationX;
    }
    
}


//MARK: - Offset Loader
class LoadMoreActivityIndicator {

    private let spacingFromLastCell: CGFloat
    private let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var scrollView: UIScrollView?

    private var defaultY: CGFloat {
        guard let height = scrollView?.contentSize.height else { return 0.0 }
        return height + spacingFromLastCell
    }

    deinit { activityIndicatorView?.removeFromSuperview() }

    init (scrollView: UIScrollView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat) {
        self.scrollView = scrollView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        self.activityIndicatorView?.tintColor = setColor(color: .text_000000_FFFFFF)
        let size:CGFloat = 40
        let frame = CGRect(x: (scrollView.frame.width-size)/2, y: scrollView.contentSize.height + spacingFromLastCell, width: size, height: size)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        if #available(iOS 13.0, *)
        {
            activityIndicatorView.color = setColor(color: .text_000000_FFFFFF)
        }
        else
        {
            activityIndicatorView.color = setColor(color: .text_000000_FFFFFF)
        }
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activityIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
    }

    private var isHidden: Bool {
        guard let scrollView = scrollView else { return true }
        return scrollView.contentSize.height < scrollView.frame.size.height
    }

    func start(closure: (() -> Void)?) {
        guard let scrollView = scrollView, let activityIndicatorView = activityIndicatorView else { return }
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY >= 0 {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta
            
            let newY = defaultY-offsetDelta
            if newY < scrollView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }

            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    closure?()
                }
            }

            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                        }
                    }
                }
            }
        }
    }

    func stop(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView , let activityIndicatorView = activityIndicatorView else { return }
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }) { _ in completion?() }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            completion?()
        }
        activityIndicatorView.stopAnimating()
    }
}
