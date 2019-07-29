//
//  UICollectionView+Shimmer.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

private var _collectionViewShimmerAssociateObjectValue: Int = 2


// Accessible Method
extension UICollectionView {
    func startShimmerAnimation(withIdentifier: String, numberOfRows: Int? = 2, numberOfSections: Int? = 2) {
        // Activate Swizzle method !
        UICollectionView.Swizzle()
        
        addCollectionViewKey(key: self.hash)
        collectionViewShimmer?.numberOfRows = numberOfRows ?? 2
        collectionViewShimmer?.numberOfSections = numberOfSections ?? 2
        collectionViewShimmer?.identifierCell = withIdentifier
        collectionViewShimmer?.delegateBeforeShimmer = self.delegate
        collectionViewShimmer?.dataSourceBeforeShimmer = self.dataSource
        
        self.dataSource = collectionViewShimmer
        self.delegate = collectionViewShimmer
        self.reloadData()
    }
    
    override func stopShimmerAnimation(animated: Bool = true) {
        removeCollectionViewKey(key: self.hash)
        if animated {
            UIView.transition(with: self,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.endShimmerReloadData()
            })
        } else {
            endShimmerReloadData()
        }
    }
}

//UICollectionView Internal gestion method
extension UICollectionView {
    private func endShimmerReloadData() {
        self.dataSource = self.collectionViewShimmer?.dataSourceBeforeShimmer
        self.delegate = self.collectionViewShimmer?.delegateBeforeShimmer
        self.reloadData()
    }
    
    private func addCollectionViewKey(key: Int) {
        var findedKey = false
        if let collectionViewShimmer = collectionViewShimmer {
            for oldKey in collectionViewShimmer.shimmerStartedKey where oldKey == key  {
                findedKey = true
            }
            
            if !findedKey {
                collectionViewShimmer.shimmerStartedKey.append(key)
            }
        }
    }
    
    private func removeCollectionViewKey(key: Int) {
        if let collectionViewShimmer = collectionViewShimmer {
            for (index, oldKey) in collectionViewShimmer.shimmerStartedKey.enumerated() where oldKey == key  {
                collectionViewShimmer.shimmerStartedKey.remove(at: index)
            }
        }
    }
}


// Internal Variable
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
}

// Internal Shimmer protocol ( Delegate / DataSource )
internal protocol CollectionViewShimmerDelegate: UICollectionViewDelegate, UICollectionViewDataSource { }

internal class CollectionViewShimmer: NSObject {
    var numberOfRows = 2
    var numberOfSections = 2
    var identifierCell = ""
    var delegateBeforeShimmer: UICollectionViewDelegate?
    var dataSourceBeforeShimmer: UICollectionViewDataSource?
    var animated = true
    
    var shimmerStartedKey = [Int]()
    
    override init() { }
    
    internal func shimmerStarted(_forKey key: Int) -> Bool {
        var finded = false
        for oldKey in shimmerStartedKey where oldKey == key {
            finded = true
        }
        return finded
    }
}

// MARK: - Collection Shimmer delegate 
extension CollectionViewShimmer: CollectionViewShimmerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCell, for: indexPath)
        return cell
    }
}


// MARK: - Intercepte Cell instantiation
private func swizzle(_ vc: UICollectionView.Type) {
    [
        (#selector(vc.dequeueReusableCell(withReuseIdentifier:for:)), #selector(vc.ksr_dequeueReusableCell(withReuseIdentifier:for:))),
        ].forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(vc,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(vc,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}



// MARK: - Swizzle method : Intercept all cell initialisation
private var hasSwizzled = false
extension UICollectionView {
    private final class func Swizzle() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc func ksr_dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = self.ksr_dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if collectionViewShimmer?.shimmerStarted(_forKey: hash) ?? false {
            cell.stopShimmerAnimation(animated: false)
            cell.startShimmerAnimation()
        } else {
            cell.stopShimmerAnimation(animated: false)
        }
        return cell
    }
}
