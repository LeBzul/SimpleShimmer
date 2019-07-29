//
//  ViewController.swift
//  ShimmerView
//
//  Created by Drouin on 24/06/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var on = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startShimmerAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func onOff() {
        if on {
           on = false
           stopShimmerAnimation()
        } else {
           on = true
           startShimmerAnimation()
        }
    }
}
