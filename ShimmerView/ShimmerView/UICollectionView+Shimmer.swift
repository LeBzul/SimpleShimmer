//
//  UICollectionView+Shimme.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import Foundation

import UIKit

private var _collectionViewShimmerAssociateObjectValue: Int = 2

extension UICollectionView {
    var collectionViewShimmer: CollectionViewShimmer? {
        get {
            return _collectionViewShimmer
        }
        set {
            self._collectionViewShimmer = newValue
        }
    }
    
    private var _collectionViewShimmer: CollectionViewShimmer? {
        get {
            if let shimmer = objc_getAssociatedObject(self, &_collectionViewShimmerAssociateObjectValue) as? CollectionViewShimmer {
                return shimmer
            } else {
                collectionViewShimmer = CollectionViewShimmer()
                return collectionViewShimmer
            }
        }
        set {
            return objc_setAssociatedObject(self, &_collectionViewShimmerAssociateObjectValue,
                                            newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func startShimmerAnimation(withIdentifier: String, numberOfRows: Int? = 2, numberOfSections: Int? = 2) {
        self.isScrollEnabled = false
        collectionViewShimmer?.numberOfRows = numberOfRows ?? 2
        collectionViewShimmer?.numberOfSections = numberOfSections ?? 2
        collectionViewShimmer?.identifierCell = withIdentifier
        collectionViewShimmer?.delegateBeforeShimmer = self.delegate
        collectionViewShimmer?.dataSourceBeforeShimmer = self.dataSource
        
        self.dataSource = collectionViewShimmer
        self.delegate = collectionViewShimmer
        self.reloadData()
    }
    
    override func stopShimmerAnimation() {
        collectionViewShimmer?.shimmerStarted = false
        self.reloadData()
        
        // add timer for reset all shimmer cell before reloadData
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            
            self.isScrollEnabled = true
            self.dataSource = self.collectionViewShimmer?.dataSourceBeforeShimmer
            self.delegate = self.collectionViewShimmer?.delegateBeforeShimmer
            self.reloadData()
        })
    }
}

internal protocol CollectionViewShimmerDelegate: UICollectionViewDelegate, UICollectionViewDataSource { }

internal class CollectionViewShimmer: NSObject {
    var numberOfRows = 2
    var numberOfSections = 2
    var identifierCell = ""
    var delegateBeforeShimmer: UICollectionViewDelegate?
    var dataSourceBeforeShimmer: UICollectionViewDataSource?
    var shimmerStarted = true
    
    override init() { }
}

extension CollectionViewShimmer: CollectionViewShimmerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        
        return cell
    }
    
    
    
}
