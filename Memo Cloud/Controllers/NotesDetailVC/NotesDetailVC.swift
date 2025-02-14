//
//  NotesDetailVC.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 14/02/2025.
//

import UIKit
import DropDown

class NotesDetailVC: BaseVC {

    
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var menuView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descriptionLbl: UITextView!
    
    
    
    let menuArr = ["Edit","Delete"]
    var subTitle : String?
    var content : Contents?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.menuView.isHidden = true
        if let userData = AppUserDefaults.shared.retrieveUserData(){
            self.menuView.isHidden = userData.id == content?.userId ? false:true
        }
        
       
        self.screenTitle.text = self.subTitle?.capitalized
        
        self.titleLbl.text = self.content?.title
        self.descriptionLbl.text = self.content?.description
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func dismissVc(_ sender: Any) {
        self.vibrate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.vibrate()
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = menuView // UIView or UIBarButtonItem
//        dropDown.width = menuView.bounds.width - 20
        dropDown.direction = .bottom
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = menuArr
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectRow(at: 0)
        
        
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          
            
            
        }
        dropDown.backgroundColor = .white
        dropDown.selectedTextColor = .black
        dropDown.selectionBackgroundColor = .white
        dropDown.dimmedBackgroundColor = .clear
        dropDown.cornerRadius = 10
        dropDown.show()
        
    }
    
    
    

}



