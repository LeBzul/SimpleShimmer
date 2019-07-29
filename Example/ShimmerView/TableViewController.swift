//
//  TableViewController.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var shimmer = TableViewShimmer()
    
    
    var numberOfRowsInSection = 0
    var numberOfSections = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        self.tableView.startShimmerAnimation(withIdentifier: "shimmerCell", numberOfRows: 2, numberOfSections: 5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.numberOfRowsInSection = 2
            self.numberOfSections = 3
            self.tableView.stopShimmerAnimation(animated: true)
        })
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shimmerCell", for: indexPath)
        cell.setNeedsLayout()
        cell.setNeedsDisplay()
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
}
