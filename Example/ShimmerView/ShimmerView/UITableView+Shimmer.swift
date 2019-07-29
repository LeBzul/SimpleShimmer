//
//  UITableView+Shimmer.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

private var _tableViewShimmerAssociateObjectValue: Int = 1

// Accessible Method
extension UITableView {
    
    func startShimmerAnimation(withIdentifier: String, numberOfRows: Int? = 2, numberOfSections: Int? = 2) {
        // Activate Swizzle method !
        UITableView.Swizzle()
        
        addTableViewKey(key: self.hash)
        
        tableViewShimmer?.numberOfRows = numberOfRows ?? 2
        tableViewShimmer?.numberOfSections = numberOfSections ?? 2
        tableViewShimmer?.identifierCell = withIdentifier
        tableViewShimmer?.delegateBeforeShimmer = self.delegate
        tableViewShimmer?.dataSourceBeforeShimmer = self.dataSource
        
        self.dataSource = tableViewShimmer
        self.delegate = tableViewShimmer
        
        UIView.transition(with: self,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
    
    override func stopShimmerAnimation(animated: Bool = true) {
        removeTableViewKey(key: self.hash)
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

//UITableView Internal gestion method
extension UITableView {
    private func endShimmerReloadData() {
        self.dataSource = self.tableViewShimmer?.dataSourceBeforeShimmer
        self.delegate = self.tableViewShimmer?.delegateBeforeShimmer
        self.reloadData()
    }
    
    private func addTableViewKey(key: Int) {
        var findedKey = false
        if let tableViewShimmer = tableViewShimmer {
            for oldKey in tableViewShimmer.shimmerStartedKey where oldKey == key  {
                findedKey = true
            }
            
            if !findedKey {
                tableViewShimmer.shimmerStartedKey.append(key)
            }
        }
    }
    
    private func removeTableViewKey(key: Int) {
        if let tableViewShimmer = tableViewShimmer {
            for (index, oldKey) in tableViewShimmer.shimmerStartedKey.enumerated() where oldKey == key  {
                tableViewShimmer.shimmerStartedKey.remove(at: index)
            }
        }
    }
}

// Internal Variable
extension UITableView {
     internal var tableViewShimmer: TableViewShimmer? {
        get {
            return _tableViewShimmer
        }
        set {
            self._tableViewShimmer = newValue
        }
    }

    private var _tableViewShimmer: TableViewShimmer? {
        get {
            if let shimmer = objc_getAssociatedObject(self, &_tableViewShimmerAssociateObjectValue) as? TableViewShimmer {
                return shimmer
            } else {
                tableViewShimmer = TableViewShimmer()
                return tableViewShimmer
            }
        }
        set {
            return objc_setAssociatedObject(self, &_tableViewShimmerAssociateObjectValue,
                                            newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// Internal Shimmer protocol ( Delegate / DataSource )
internal protocol TableViewShimmerDelegate: UITableViewDataSource, UITableViewDelegate { }

internal class TableViewShimmer: NSObject {

    var numberOfRows = 2
    var numberOfSections = 2
    var identifierCell = ""
    var delegateBeforeShimmer: UITableViewDelegate?
    var dataSourceBeforeShimmer: UITableViewDataSource?
    
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

// Extension of Internal Shimmer protocol ( Delegate / DataSource )
extension TableViewShimmer: TableViewShimmerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28))
        view.withShimmer = true
        shimmerStarted(_forKey: tableView.hash) ? view.startShimmerAnimation() : view.stopShimmerAnimation(animated: false)
        
        return view
    }
}

// Intercepte Cell instantiation
private func swizzle(_ vc: UITableView.Type) {
    [
        (#selector(vc.dequeueReusableCell(withIdentifier:)), #selector(vc.ksr_dequeueReusableCell(withIdentifier:))),
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

private var hasSwizzled = false
extension UITableView {
    private final class func Swizzle() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self)
    }

    @objc func ksr_dequeueReusableCell(withIdentifier identifier: String ) -> UITableViewCell? {
        let cell = self.ksr_dequeueReusableCell(withIdentifier: identifier)
        
        if tableViewShimmer?.shimmerStarted(_forKey: hash) ?? false {
            cell?.stopShimmerAnimation(animated: false)
            cell?.startShimmerAnimation()
            cell?.selectionStyle = .none
        } else {
            cell?.stopShimmerAnimation(animated: false)
            cell?.selectionStyle = .default
        }
        return cell
    }
}
