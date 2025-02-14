//
//  ListVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 30/10/2024.
//

import UIKit

struct List: Codable, Equatable {
    let id: Int
    let name: String
}

class ListVC: BaseVC, UISearchBarDelegate {

    
    @IBOutlet weak var tableView : UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.sectionHeaderTopPadding = 0.0
            tableView.registerNib(ListTVC.identifier)
        }
    }
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    
    
    var list: [List] = []
    var filteredlist: [List] = []
    var selectedlist: [List] = []
    var selectedCategories: [List] = []
    
    
    var titleName: String = ""
    var isMultiple : Bool = false
    
    
    
    var type: ConfigType = .categories
    var onSelectionCompletion: (([List], ConfigType) -> Void)?
    var onCancelnCompletion: ((List) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        self.searchBar.delegate = self
        self.saveBtn.isHidden = self.selectedlist.count == 0 ? true:false
    
        let title = self.selectedlist.count == 0 ? "" : "Reset"
        self.saveBtn.setTitle(title, for: UIControl.State.normal)
        
        if isMultiple {
//            if self.list.count > 1 {
//                self.list.removeFirst()
//            }
            
            self.saveBtn.isHidden = false
            self.saveBtn.setTitle("Done", for: UIControl.State.normal)
        }
        
        self.filteredlist = list
        self.screenTitle.text = titleName
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
//        let list = self.selectedlist.first ?? List(id: 0, name: "All Countries", imageUrl: nil, count: 0)
//        
//        self.onCancelnCompletion?(list)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.selectedlist.count != 0 && isMultiple == false {
            
            self.selectedlist.removeAll()
            self.tableView.reloadData()
            
            
        }
        let list = self.selectedlist.count != 0  ? self.selectedlist : []
        
        
        
        onSelectionCompletion?(list, type)
        self.dismiss(animated: true)
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredlist = list
            } else {
                // Filter the countries array based on the search text
                filteredlist = list.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
            
            // Reload your data (e.g., tableView or collectionView)
            // tableView.reloadData()
            print("Filtered countries: \(filteredlist)")
            self.tableView.reloadData()
    }
    
    
    

}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC else {fatalError()}
        
        let list = self.filteredlist[indexPath.row]
        
        
        cell.name.textColor = setColor(color: .text_000000_FFFFFF)
        if selectedlist.contains(where: { $0.id == list.id }) {
            cell.accessoryType = .checkmark
            
            cell.name.textColor = setColor(color: .color_3563E9)
        } else {
            cell.accessoryType = .none
        }
        
        cell.configure(with: list, type: type)
        
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = self.filteredlist[indexPath.row]
        if self.selectedlist.contains(where: { $0.id == list.id }) {
            self.selectedlist.removeAll(where: { $0.id == list.id })
        }else{
            self.selectedlist.append(list)
        }
        
        print(self.selectedlist)
        
        self.tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}



