//
//  UITableView+Shimmer.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

private var _tableViewShimmerAssociateObjectValue: Int = 1

extension UITableView {
     var tableViewShimmer: TableViewShimmer? {
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

    func startShimmerAnimation(withIdentifier: String, numberOfRows: Int? = 2, numberOfSections: Int? = 2) {
        self.isScrollEnabled = false
        tableViewShimmer?.shimmerStarted = true
        tableViewShimmer?.numberOfRows = numberOfRows ?? 2
        tableViewShimmer?.numberOfSections = numberOfSections ?? 2
        tableViewShimmer?.identifierCell = withIdentifier
        tableViewShimmer?.delegateBeforeShimmer = self.delegate
        tableViewShimmer?.dataSourceBeforeShimmer = self.dataSource
        
        self.dataSource = tableViewShimmer
        self.delegate = tableViewShimmer
        self.reloadData()
    }

    override func stopShimmerAnimation(animated: Bool = true) {
        tableViewShimmer?.shimmerStarted = false
        tableViewShimmer?.animatedStop = animated
        self.reloadData()
        
        // add timer for reset all shimmer cell before reloadData
        let deadline = animated ? (DispatchTime.now() + 0.3) : DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.isScrollEnabled = true
            self.dataSource = self.tableViewShimmer?.dataSourceBeforeShimmer
            self.delegate = self.tableViewShimmer?.delegateBeforeShimmer
            self.reloadData()
        })
    }
}

internal protocol TableViewShimmerDelegate: UITableViewDataSource, UITableViewDelegate { }

internal class TableViewShimmer: NSObject {
    var numberOfRows = 2
    var numberOfSections = 2
    var identifierCell = ""
    var delegateBeforeShimmer: UITableViewDelegate?
    var dataSourceBeforeShimmer: UITableViewDataSource?
    var shimmerStarted = true
    var animatedStop = true

    override init() { }
}

extension TableViewShimmer: TableViewShimmerDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        if shimmerStarted {
            cell.selectionStyle = .none
            cell.stopShimmerAnimation(animated: false)
            cell.startShimmerAnimation()
        } else {
            cell.selectionStyle = .default
            cell.stopShimmerAnimation(animated: animatedStop)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.withShimmer = true
        if shimmerStarted {
            view.startShimmerAnimation()
        } else {
            view.stopShimmerAnimation(animated: animatedStop)
        }
        
        return view
    }
}
