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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tableView.startShimmerAnimation(withIdentifier: "shimmerCell", numberOfRows: 25, numberOfSections: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.tableView.stopShimmerAnimation(animated: false)
        })
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shimmerCell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
}
