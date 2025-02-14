//
//  SettingsVC.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 23/10/2024.
//

import UIKit

class SettingsVC: BaseVC {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var appVersionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.buttonPressAnimation(sender: self.backBtn)
        guard let appVersion = getAppVersion() else {
            print("App version not found.")
            return
        }
        self.appVersionLbl.text = "Version \(appVersion)"
        self.tblReloadData()
    }
    
    
    @IBAction func dismissVc(_ sender: Any) {
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickOnChangePassword(_ sender: Any) {
        self.vibrate()
        SceneDelegate.sharedInstance.pushToPasswordUpdate()
    }
    
    
    @IBAction func click_logOutBtn(_ sender: UIButton) {
        self.vibrate()        
        self.showAlertConfirmationButtons(message: "Are you sure you want to logout?",btnTitle: "Logout") { _ in
            self.logoutApi()
            
        }
    }
    
    
    func tblReloadData() {
        
        if let userData = AppUserDefaults.shared.retrieveUserData() {
            self.lblUsername.text = userData.name.capitalized
        }
    }
    
    
    
}

//MARK: API
extension SettingsVC {
    
    func logoutApi(){
        
        
        self.view.aj_showDotLoadingIndicator()
        
        let user = AppUserDefaults.shared.retrieveUserData()
        let parameters: [String: Any] = [:]
        
        
        NetworkManager.shared.call(target: Apis.logout(params: parameters)) { (result: Result<RequestResponse<noData>, NetworkError>) in
                    
            print("Result: \(result)")
            self.view.aj_hideDotLoadingIndicator()
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    
                    
                    AppUserDefaults.shared.clearAllUserData()
                    SceneDelegate.sharedInstance.pushToLoginRoot()
                    self.showMessage(title: response.message, state: .success)
                    
                   
                } else {
                    // Handle the case when success is false
                    print("failed message: \(response.message)")
                    
                    self.showMessage(title: response.message, state: .error)
                    
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

