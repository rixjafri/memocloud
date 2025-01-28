//
//  CellRegister+Extension.swift
//  BookOfMormonComics
//
//  Created by Darshit on 11/11/20.
//  Copyright © 2020 Darshit. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UITableView
public extension UITableView {

    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }

    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK:- UICollectionView
public extension UICollectionView {

    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }

    func registerHeaderCell(type:UICollectionReusableView.Type, supplementaryViewOfKind: String, identifier: String? = nil) {
        let headerId = String(describing: type)
        register(UINib(nibName: headerId, bundle: nil), forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: identifier ?? headerId)
    }

    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }

    func dequeueHeaderView<T: UICollectionReusableView>(viewForSupplementaryElementOfKind kind: String, withType type: UICollectionReusableView.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.headerIdentifier, for: indexPath) as? T
    }
    
}

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UICollectionReusableView {
    static var headerIdentifier: String {
        return String(describing: self)
    }
}
