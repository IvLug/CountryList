//
//  CostomTransition.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 10.05.2022.
//

import UIKit

protocol CostomTransitionProtocol: AnyObject {
    func convertImage(to coordinateSpace: UICoordinateSpace) -> CGRect
    func getSnapshot() -> UIView?
    func configureTransition(value: Bool)
}

class CostomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var delegate: CostomTransitionProtocol!

    private let firstViewController: UIViewController
    private let secondViewController: UIViewController
    private var selectedViewSnapshot: UIView
    let operation: UINavigationController.Operation

    private let imageViewRect: CGRect
    var selectedView: UIView?

    init?(operation: UINavigationController.Operation,
          firstViewController: UIViewController,
          secondViewController: UIViewController,
          selectedViewSnapshot: UIView
    ) {
        self.operation = operation
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedViewSnapshot = selectedViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window else { return nil }
             // let selectedCell = firstViewController.selectedCell else { return nil }

        imageViewRect = delegate.convertImage(to: window)
        
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if operation == .push {
            guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
                  let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                  let toView = transitionContext.view(forKey: .to)
            else {
                transitionContext.completeTransition(true)
                return
            }
            let containerView = transitionContext.containerView

            pushAnimate(
                toView: toView,
                containerView: containerView,
                toViewController: toViewController,
                fromViewController: fromViewController,
                transitionContext: transitionContext
            )

        } else if operation == .pop {
            guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
                  let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                transitionContext.completeTransition(true)
                return
            }
            let containerView = transitionContext.containerView

            popAnimate(
                containerView: containerView,
                toViewController: toViewController,
                fromViewController: fromViewController,
                transitionContext: transitionContext
            )
        }
    }

    func pushAnimate(
        toView: UIView,
        containerView: UIView,
        toViewController: UIViewController,
        fromViewController: UIViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        selectedViewSnapshot.frame = imageViewRect
        toView.clipsToBounds = true
        containerView.addSubview(toView)
        //secondViewController.heroImage.alpha = 0
        delegate.configureTransition(value: true)
        toViewController.view.alpha = 0
        containerView.addSubview(selectedViewSnapshot)

        UIView.animate(withDuration: transitionDuration(using: transitionContext) * 2, animations: { [self] in
            self.selectedViewSnapshot.frame = CGRect(x: toView.center.x,
                                                              y: toView.center.y,
                                                              width: toView.frame.width,
                                                              height: toView.frame.width
            )
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
        },
        completion: { _ in
            self.delegate.configureTransition(value: false)
//            self.secondViewController.heroImage.alpha = 1
            self.selectedViewSnapshot.removeFromSuperview()
        })
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 2,
                       options: [.layoutSubviews],
                       animations: {
                        toViewController.view.frame = containerView.bounds
                        fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0)
                       },
                       completion: { _ in
                        transitionContext.completeTransition(true)
                       })
    }

    func popAnimate(
        containerView: UIView,
        toViewController: UIViewController,
        fromViewController: UIViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0

        UIView.animate(withDuration: transitionDuration(using: transitionContext) * 2) {
            self.selectedViewSnapshot.alpha = 0
            toViewController.view.alpha = 1
            fromViewController.view.alpha = 0
        }
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.layoutSubviews],
            animations: {
                fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.width, dy: 0)
                toViewController.view.frame = containerView.bounds
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}

