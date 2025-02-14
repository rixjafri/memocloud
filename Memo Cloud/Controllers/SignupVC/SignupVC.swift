//
//  SignupVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 28/01/2025.
//

import UIKit

class SignupVC: BaseVC, UITextFieldDelegate {

    
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var signupBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.fullName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
        
        // Do any additional setup after loading the view.
        self.buttonPressAnimation(sender: self.signupBtn)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func dissmissVC(_ sender: UIButton) {
        
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signupAction(_ sender: UIButton) {
        
        if !validateName(self.fullName.text!) {
            self.showMessage(title: "The name provided is invalid. Please enter a valid name.", state: .error)
            
        }else if !validateEmail(self.email.text!) {
            self.showMessage(title: "The email provided is invalid. Please enter a valid email.", state: .error)
            
        }else if !validatePassword(self.password.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else if self.password.text != self.confirmPassword.text{
            self.showMessage(title: "Password and Confirm Password do not match.", state: .error)
            
        }else {
            self.signupApi()
        }
    }
    
    
    @IBAction func termsAndConditions(_ sender: UIButton) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder (next text field)
        
        if textField == self.fullName {
            self.email.becomeFirstResponder()
        }else if textField == self.email {
            self.password.becomeFirstResponder()
        }else if textField == self.password {
            self.confirmPassword.becomeFirstResponder()
        }else{
            self.signupAction(UIButton())
            textField.resignFirstResponder()
        }
        
        return true
    }
    

}


//MARK: API
extension SignupVC {
    
    func signupApi(){
        self.view.aj_showDotLoadingIndicator()
        
        let parameters = [LoginParms.name : self.fullName.text!,
                          LoginParms.email : self.email.text!,
                          LoginParms.password :  self.password.text!,] as [String : Any]
        
        
        NetworkManager.shared.call(target: Apis.signup(params: parameters)) { (result: Result<RequestResponse<User>, NetworkError>) in
                    
            print("Result: \(result)")
            self.view.aj_hideDotLoadingIndicator()
            
            switch result {
            case .success(let response):
                if response.success {
                    // Check if user data exists in the response
                    if let user = response.data {
                        print("User Data: \(user)")
                        
                        AppUserDefaults.shared.saveUserData(user: user)
                        AppUserDefaults.shared.setUserToken(response.token ?? "")
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
