//
//  PasswordVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 22/10/2024.
//

import UIKit

class PasswordVC: BaseVC, UITextFieldDelegate {

    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var password: UITextField!
    var username: String = ""
    var otp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.password.delegate = self
        // Do any additional setup after loading the view.
        self.buttonPressAnimation(sender: self.sendBtn)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        
        if !validatePassword(self.password.text!) {
            self.showMessage(title: "The password provided is invalid. Please enter a valid password.", state: .error)
            
        }else {
           
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the next responder (next text field)
        
        if textField == self.password {
            self.sendBtnAction(self.sendBtn)
            textField.resignFirstResponder()
        }
        
        
       
        return true
    }


}

//MARK: API
extension PasswordVC {
    
    
}
