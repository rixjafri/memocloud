//
//  QuickMenu.swift
//  Scandex
//
//  Created by Parth Miroliya on 20/03/23.
//

import UIKit

protocol QuickMenuDelegate : NSObject {
    func didHidePopup()
}

class QuickMenu : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewMain: UIViewX!
    @IBOutlet weak var closeButton: UIButton!
    
    
    public static let sharedInstance = QuickMenu()
    var superVC = UIViewController()
    
    var delegate : QuickMenuDelegate!
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func showPopup(vc:UIViewController,dalagate: QuickMenuDelegate, parentview:UIView, frame: CGRect) {
        
        
        
        
        
        self.delegate = dalagate
        self.superVC = vc
        self.show(vc:vc, parentview: parentview,frame: frame)
        self.configureView(nibName: "QuickMenu", frame: frame)
        //self.closeButton.dropShadow()
        SceneDelegate.sharedInstance.floatingButton.floatingWindow?.topView.isHidden = true
        
        
    }
    
    
    func hide(duration:TimeInterval=0.5) {
        self.delegate.didHidePopup()
        Animations.transitionOut.performAnimation(forView:self, duration: duration)
        UIView.animate(withDuration: 0.5) {
            SceneDelegate.sharedInstance.floatingButton.floatingWindow?.topView.isHidden = false
        }
    }
    
    private func show(vc:UIViewController, parentview:UIView, frame: CGRect) {
        ApiUtillity.sharedInstance.AddSubViewtoParentViewWithRect(parentview: parentview, subview: self,frame: frame)
        Animations.easeIn.performAnimation(forView: self, duration: 0.25)
        
    }
    
    @IBAction func clickOnClose(_ sender: UIButton) {
        self.hide()
    }
    
    @IBAction func clickOnMenu(_ sender: UIButton) {
        self.hide()
        
        
        switch sender.tag {
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("scannerOpen"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("scannerOpen"), object: nil)
        default:
            SceneDelegate.sharedInstance.pushToUpload(type: sender.tag)
        }
        
        
        
    }
    
}

extension QuickMenu {
    fileprivate func configureView(nibName name: String, frame: CGRect) {
        if contentView != nil {
            contentView.removeFromSuperview()
        }
        contentView = configureNib(nibName: name)
        
        var rect = frame
        rect.origin.x = 0
        rect.origin.y = 0
        contentView.frame = rect
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
   
    private func configureNib(nibName name: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
