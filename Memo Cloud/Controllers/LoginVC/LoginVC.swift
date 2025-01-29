//
//  LoginVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 26/09/2024.
//

import UIKit
import KeychainAccess

class LoginVC: BaseVC, UITextFieldDelegate {

    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signupBtn: UIButton!
    

    
    let keychainService = KeychainService(service: "com.app.memocloud")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.email.delegate = self
        self.password.delegate = self
        // Add target for touch down and touch up events
        self.buttonPressAnimation(sender: self.loginBtn)
        self.buttonPressAnimation(sender: self.signupBtn)
        
        self.hideKeyboardWhenTappedAround()
        
        
           
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.hideNavigationBar()
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        
        if !validateEmail(self.email.text!) {
            self.showMessage(title: "The email provided is invalid. Please enter a valid email.", state: .error)
            
        }else if !validatePassword(self.password.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else {
            self.loginApi()
        }
        
        
        
    }
    
    
    @IBAction func signupAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.storyBoard(withName: .auth).loadViewController(withIdentifier: .signup) as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func termsAndPolicyAction(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder (next text field)
        
        if textField == self.email {
            self.password.becomeFirstResponder()
        }else{
            self.loginAction(UIButton())
            textField.resignFirstResponder()
        }
        
        
       
        return true
    }
}

//MARK: API
extension LoginVC {
    
    func loginApi(){
        self.view.aj_showDotLoadingIndicator()
        
        let parameters = [LoginParms.email : self.email.text!,
                          LoginParms.password :  self.password.text!,] as [String : Any]
        
        
        NetworkManager.shared.call(target: Apis.login(params: parameters)) { (result: Result<RequestResponse<UserData>, NetworkError>) in
                    
            print("Result: \(result)")
            self.view.aj_hideDotLoadingIndicator()
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    if let userData = response.data {
                        print("User Data: \(userData)")
                        
                        AppUserDefaults.shared.saveUserData(userData: userData)
                        AppUserDefaults.shared.setUserToken(userData.token)
                        AppUserDefaults.shared.setLoggedIn(true)
                        
                        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .dashboardVC) as! DashboardVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        self.showMessage(title: response.message, state: .success)
                        
                    } else {
                        print("No user data available.")
                        self.showMessage(title: "No user data available.", state: .error)
                    }
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
