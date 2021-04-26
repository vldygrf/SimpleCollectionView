//
//  SimpleLayout.swift
//  SimpleCollectionView
//
//  Created by Vladislav Garifulin on 25.04.2021.
//

import UIKit

final class SimpleLayout: UICollectionViewFlowLayout {
    private var indexPathToRemove: IndexPath?
    private let spacing: CGFloat = 10.0
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        let numOfColumns: CGFloat = 1
        let size: CGFloat = (collectionView.frame.size.width - (spacing * (numOfColumns + 1))) / numOfColumns
        itemSize = CGSize(width: size, height: size)
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for update in updateItems {
            if (update.updateAction == .delete) {
                indexPathToRemove = update.indexPathBeforeUpdate
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        indexPathToRemove = nil
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if (indexPathToRemove == itemIndexPath) {
            guard
                let collectionView = collectionView,
                let cell = collectionView.cellForItem(at: itemIndexPath)
            else {
                return attributes
            }
            
            attributes?.transform = cell.transform
        }
        
        return attributes
    }
}
