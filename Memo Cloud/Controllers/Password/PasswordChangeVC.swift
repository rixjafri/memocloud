//
//  PasswordChangeVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 13/12/2024.
//

import UIKit

class PasswordChangeVC: BaseVC, UITextFieldDelegate {

    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    var username: String = ""
    var otp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newPassword.delegate = self
        // Do any additional setup after loading the view.
        self.buttonPressAnimation(sender: self.sendBtn)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        
        if !validatePassword(self.oldPassword.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else if !validatePassword(self.newPassword.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else if !validatePassword(self.confirmPassword.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else if self.confirmPassword.text != self.newPassword.text {
            self.showMessage(title: "The password provided is invalid. New password and confirm password do not match.", state: .error)
            
        }else if self.oldPassword.text == self.newPassword.text {
            self.showMessage(title: "The password provided is invalid. New password cannot be the same as the old password.", state: .error)
            
        }else {
            self.updatePasswordApi()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder (next text field)
        
        if textField == self.newPassword {
            self.sendBtnAction(self.sendBtn)
            textField.resignFirstResponder()
        }
        
        
       
        return true
    }
    
    @IBAction func dismissVc(_ sender: Any) {
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }


}

//MARK: API
extension PasswordChangeVC {
    
    func updatePasswordApi(){
        
        
    }
}
