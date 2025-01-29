//
//  SignupVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 28/01/2025.
//

import UIKit

class SignupVC: BaseVC {

    
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var signupBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buttonPressAnimation(sender: self.signupBtn)
    }
    
    
    @IBAction func dissmissVC(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func signupAction(_ sender: UIButton) {
    }
    
    
    @IBAction func termsAndConditions(_ sender: UIButton) {
    }
    

}
