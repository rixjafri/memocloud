//
//  CustomFlowLayout.swift
//  Hey Peers
//
//  Created by mac pro on 1/28/20.
//  Copyright © 2020 sigmacoder. All rights reserved.
//

import Foundation
import UIKit

@objc
class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int
    var itemHeight : Int = 230
    

    @objc init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero , itemheight: Int = 230) {
        self.cellsPerRow = cellsPerRow
        self.itemHeight  = itemheight
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        if #available(iOS 11.0, *) {
            let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            itemSize = CGSize(width: itemWidth, height: CGFloat(itemHeight))
        } else {
            // Fallback on earlier versions
        }
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
