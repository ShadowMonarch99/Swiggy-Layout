//
//  CustomTransition.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    var initialFrame: CGRect
    
    init(isPresenting: Bool, initialFrame: CGRect) {
        self.isPresenting = isPresenting
        self.initialFrame = initialFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            // Initial frame is where the animation starts
            toView.frame = initialFrame
            toView.layer.cornerRadius = 15 // Match the cell's corner radius
            toView.clipsToBounds = true
            
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = containerView.bounds // Expand to full screen
                toView.layer.cornerRadius = 0 // Remove corner radius
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            // Animate back to the cell's frame
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = self.initialFrame // Shrink back to original position
                fromView.layer.cornerRadius = 15 // Add back corner radius
            }) { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
