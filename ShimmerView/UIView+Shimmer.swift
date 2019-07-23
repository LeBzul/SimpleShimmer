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
        get {
            return _withShimmer
        }
        set {
            self._withShimmer = newValue
        }
    }

    private var _withShimmer: Bool {
        get {
            return objc_getAssociatedObject(self, &_withShimmerAssociateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &_withShimmerAssociateObjectValue,
                                            newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc func startShimmerAnimation() {
        findShimmerAndActive(self)
    }

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
    }

    /*
     * Add shimmer view and start gradient animation
     */
    private func addShimmerView(_ view: UIView) {
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let shimmerView = UIView.init(frame: rect)
        shimmerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        shimmerView.layer.cornerRadius = view.layer.cornerRadius
        shimmerView.tag = UIView.shimmer_tag
        shimmerView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        gradientLayer.frame = shimmerView.bounds
        shimmerView.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.2
        animation.fromValue = -shimmerView.frame.size.width
        animation.toValue = shimmerView.frame.size.width
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "animationShimmerView")
        
        let shimmerViewBackground = UIView.init(frame: rect)
        shimmerViewBackground.layer.cornerRadius = view.layer.cornerRadius
        shimmerViewBackground.backgroundColor = UIColor.white
        shimmerViewBackground.tag = UIView.shimmer_tag
        
        view.addSubview(shimmerViewBackground)
        view.addSubview(shimmerView)
        
        shimmerViewBackground.bringSubviewToFront(view)
        shimmerView.bringSubviewToFront(view)
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
