//
//  AnimationController.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 03/01/2022.
//

import Foundation
import UIKit

final class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var isPush : Bool = true
    
    func setTransitionType(isPush: Bool) {
        self.isPush = isPush
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        if let toVc   = toViewController,
           let fromVc = fromViewController {
            transitionContext.finalFrame(for: toVc)
            transitionContext.containerView.addSubview(toVc.view)
            
            toVc.view.alpha = 0.0
            
            let animations = { self.applyAnimation(fromVc: fromVc, toVc: toVc) }
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                           animations: animations,
                           completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    private func applyAnimation(fromVc: UIViewController, toVc: UIViewController) {
        if isPush {
            fromVc.view.transform = CGAffineTransform(translationX: 0, y: -500)
//            fromVc.view.frame = CGRect(x: fromVc.view.frame.minX, y: fromVc.view.frame.minY - 500, width: fromVc.view.frame.width, height: fromVc.view.frame.height)
        } else {
            fromVc.view.frame = CGRect(x: fromVc.view.frame.minX, y: fromVc.view.frame.minY + 500, width: fromVc.view.frame.width, height: fromVc.view.frame.height)
        }
        
        toVc.view.alpha = 1.0
    }
}
