//
//  ListTVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 31/10/2024.
//

import UIKit

class ListTVC: UITableViewCell {
 
    
    @IBOutlet var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with list: List, type: ConfigType = .categories) {
        name.text = "#\(list.name)"
        
    }
}
