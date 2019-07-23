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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLinesArrayFromLabel(label: label)
        startShimmerAnimation()
    }

    @IBAction func onOff() {
        if on {
           on = false
           stopShimmerAnimation(animated: false)
        } else {
           on = true
           startShimmerAnimation()
        }
    }

    func getLinesArrayFromLabel(label: UILabel) {
        if let font = label.font {
            var unichars = [UniChar]("P".utf16)
            var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
            let gotGlyphs = CTFontGetGlyphsForCharacters(label.font, &unichars, &glyphs, unichars.count)
            if gotGlyphs {
                let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
              //  var inverse = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -cgpath.boundingBox.height - 1)
                var transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
                let path = UIBezierPath(cgPath: cgpath.copy(using: &transform)!)
                print(path)
            }
        }
    }
}
