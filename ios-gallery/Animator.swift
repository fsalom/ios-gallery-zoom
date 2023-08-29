//
//  Animator.swift
//  ios-gallery
//
//  Created by Fernando Salom Carratala on 28/8/23.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.5

    private let type: PresentationType
    private let firstViewController: UIViewController
    private let secondViewController: UIViewController
    private var imageViewSnapshot: UIView
    private let imageViewRect: CGRect

    init?(type: PresentationType,
          firstViewController: UIViewController,
          secondViewController: UIViewController,
          imageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.imageViewSnapshot = imageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window
            else { return nil }

        self.imageViewRect = imageViewSnapshot.convert(imageViewSnapshot.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = secondViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }
        toView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)

        containerView.addSubview(toView)

        guard
            let window = firstViewController.view.window ?? secondViewController.view.window,
            let imageSnapshot = imageViewSnapshot.snapshotView(afterScreenUpdates: true),
            let vc = secondViewController as? PageViewController,
            let controllerImageSnapshot = vc.imageView.snapshotView(afterScreenUpdates: true)

            else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor

        if isPresenting {
            imageViewSnapshot = imageSnapshot
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0  
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        toView.alpha = 0
        [backgroundView, imageViewSnapshot, controllerImageSnapshot].forEach { containerView.addSubview($0) }

        let controllerImageViewRect = vc.imageView.convert( vc.imageView.bounds, to: window)

        [imageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? imageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? 12 : 0
            $0.layer.masksToBounds = true
        }

        controllerImageSnapshot.alpha = isPresenting ? 0 : 1

        //imageViewSnapshot.alpha = isPresenting ? 1 : 0

        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                //self.imageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.imageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.imageViewRect
                fadeView.alpha = isPresenting ? 1 : 0

                [controllerImageSnapshot, self.imageViewSnapshot].forEach {
                    $0.layer.cornerRadius = isPresenting ? 0 : 12
                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                //self.imageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }

        }, completion: { _ in
            //self.imageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}

enum PresentationType {
    case present
    case dismiss
    var isPresenting: Bool {
        return self == .present
    }
}
