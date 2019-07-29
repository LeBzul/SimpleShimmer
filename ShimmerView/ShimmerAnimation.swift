//
//  ShimmerAnimation.swift
//  ShimmerView
//
//  Created by Drouin on 29/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

class ShimmerAnimation {
    
    static func buildAnimation(view: UIView, type: ShimmerOptions.AnimationType) {
        switch type {
        case .classic: buildClassicAnimation(view: view)
        case .fade: buildFadeAnimation(view: view)
        }
    }
    
    static private func buildFadeAnimation(view: UIView) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.9
        animation.toValue = 0.3
        let realDuration = ShimmerOptions.instance.animationAutoReserse ? (ShimmerOptions.instance.animationDuration * 2) : ShimmerOptions.instance.animationDuration
        animation.duration = CFTimeInterval(realDuration + ShimmerOptions.instance.animationDelay)
        animation.repeatCount = HUGE
        animation.autoreverses = ShimmerOptions.instance.animationAutoReserse
        
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(animation, forKey: "fade")
    }
    
    static private func buildClassicAnimation(view: UIView) {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = CFTimeInterval(ShimmerOptions.instance.animationDuration)
        
        var fromValue: CGFloat = 0
        var toValue: CGFloat = 0
        switch ShimmerOptions.instance.animationDirection {
        case .topBottom:
            animation.keyPath = "transform.translation.y"
            fromValue = -view.frame.size.height
            toValue = view.frame.size.height
        case .bottomTop:
            animation.keyPath = "transform.translation.y"
            fromValue = view.frame.size.height
            toValue = -view.frame.size.height
        case .leftRight:
            fromValue = -view.frame.size.width
            toValue = view.frame.size.width
        case .rightLeft:
            fromValue = view.frame.size.width
            toValue = -view.frame.size.width
        }
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = ShimmerOptions.instance.animationAutoReserse
        
        let group = CAAnimationGroup()
        group.animations = [animation]
        let realDuration = ShimmerOptions.instance.animationAutoReserse ? (ShimmerOptions.instance.animationDuration * 2) : ShimmerOptions.instance.animationDuration
        group.duration = CFTimeInterval(realDuration + ShimmerOptions.instance.animationDelay)
        group.repeatCount = HUGE
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.frame = view.bounds
        
        switch ShimmerOptions.instance.animationDirection {
        case .topBottom, .bottomTop:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .leftRight, .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        
        gradientLayer.add(group, forKey: "animationShimmerView")
        view.layer.mask = gradientLayer
    }
}
