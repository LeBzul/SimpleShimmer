//
//  UIView+Shimmer.swift
//  ShimmerView
//
//  Created by Drouin on 24/06/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

private var _withShimmerAssociateObjectValue: Int = 0
extension UIView {
    
    private static let shimmer_tag = 9194
    
    @IBInspectable var withShimmer: Bool {
        get { return _withShimmer }
        set { self._withShimmer = newValue }
    }

    private var _withShimmer: Bool {
        get { return objc_getAssociatedObject(self, &_withShimmerAssociateObjectValue) as? Bool ?? false }
        set { return objc_setAssociatedObject(self, &_withShimmerAssociateObjectValue,
                                            newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    @objc func startShimmerAnimation() {
        findShimmerAndActive(self)
    }

    private func findShimmerAndActive(_ view: UIView) {
        if view.withShimmer {
            addShimmerView(view)
        }
        for subView in view.subviews {
            findShimmerAndActive(subView)
        }
    }
    /*
    private func findShimmerAndActive(_ view: UIView) {
        if !view.withShimmer {
            for subView in view.subviews {
                if subView.withShimmer {
                    addShimmerView(subView)
                } else {
                    findShimmerAndActive(subView)
                }
            }
        } else {
            addShimmerView(view)
        }
    }*/

    /*
     * Add shimmer view and start gradient animation
     */
    private func addShimmerView(_ view: UIView) {
        let rectShimmer = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let shimmerView = UIView.init(frame: rectShimmer)
        
        let shimmerColor = (ShimmerOptions.instance.animationType == .classic) ? ShimmerOptions.instance.gradientColor : ShimmerOptions.instance.backgroundColor
        
        shimmerView.backgroundColor = shimmerColor
        shimmerView.tag = UIView.shimmer_tag
        ShimmerAnimation.buildAnimation(view: shimmerView, type: ShimmerOptions.instance.animationType)

        let rectBackground = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let shimmerViewBackground = UIView.init(frame: rectBackground)
        shimmerViewBackground.layer.cornerRadius = view.layer.cornerRadius
        
        let backgroundShimmer = (ShimmerOptions.instance.animationType == .classic) ? ShimmerOptions.instance.backgroundColor : UIColor.white
        
        shimmerViewBackground.backgroundColor = backgroundShimmer
        shimmerViewBackground.tag = UIView.shimmer_tag
        shimmerViewBackground.layer.borderWidth = ShimmerOptions.instance.borderWidth
        shimmerViewBackground.layer.borderColor = ShimmerOptions.instance.borderColor.cgColor
        shimmerViewBackground.layer.masksToBounds = true
        
        view.addSubview(shimmerViewBackground)
        shimmerViewBackground.addSubview(shimmerView)
        if let superView = view.superview {
            shimmerViewBackground.bringSubviewToFront(superView)
            superView.bringSubviewToFront(view)
        }
    }

    @objc func stopShimmerAnimation(animated: Bool = true) {
        removeShimmerView(self, animated: animated)
    }

    /*
     * Remove shimmer view and stop animation
     */
    private func removeShimmerView(_ view: UIView, animated: Bool) {
        for subView in view.subviews {
            if subView.tag == UIView.shimmer_tag {
                if animated {
                    UIView.animate(withDuration: 0.6, animations: {
                        subView.alpha = 0
                    }, completion: { _ in
                        subView.removeFromSuperview()
                    })
                } else {
                    subView.removeFromSuperview()
                }
            } else {
                removeShimmerView(subView, animated: animated)
            }
        }
    }
}

extension UIViewController {
    func startShimmerAnimation() {
        view.startShimmerAnimation()
    }
    func stopShimmerAnimation(animated: Bool = true) {
        view.stopShimmerAnimation(animated: animated)
    }
}
