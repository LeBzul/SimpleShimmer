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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShimmerOptions.instance.backgroundColor = UIColor.red
        ShimmerOptions.instance.gradientColor = UIColor.green
        ShimmerOptions.instance.animationType = .fade
        startShimmerAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func onOff() {
        if on {
           stopShimmerAnimation()
        } else {
           startShimmerAnimation()
        }
        
        on = !on
    }
}
