//
//  SplashVC.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 26/09/2024.
//

import UIKit
import Reachability
import Loaf



class SplashVC: BaseVC {

    let reachability = try! Reachability()
    var isNetworkAvaiable = true
    var loaf: Loaf?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            do{
              try reachability.startNotifier()
            }catch{
              print("could not start reachability notifier")
            }
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if AppUserDefaults.shared.isLoggedIn() {
            SceneDelegate.sharedInstance.pushToDashborad()
        }else{
            SceneDelegate.sharedInstance.pushToLoginRoot()
        }
        
        
        
        
        
        
    }
    
    
    
    func networkMessageConfigation(title: String){
        

        
        self.loaf = Loaf(title,
                                 state: .error,
                                 location: .top,
                                 presentingDirection: .vertical,
                                 dismissingDirection: .vertical,
                                 sender: self)
        self.loaf?.show(.custom(6000))
    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
          isNetworkAvaiable = true
          self.dismissLoaf()
      case .cellular:
          print("Reachable via Cellular")
          isNetworkAvaiable = true
          self.dismissLoaf()
      case .unavailable:
        print("Network not reachable")
          
              isNetworkAvaiable = false
              self.networkMessageConfigation(title: "No internet connection!")
          
          
      }
    }
    
    func dismissLoaf() {
        
        
            Loaf.dismiss(sender: self)
        
        
        
        
    }
    
    
}

extension SplashVC {
    
    
}
