//
//  StartController.swift
//  ios-gallery
//
//  Created by Fernando Salom Carratala on 22/8/23.
//

import Foundation
import UIKit

class StartViewController: UIViewController, AnimatorProtocol {
    var animator: Animator?
    @IBOutlet weak var imageView: UIImageView!
    var imageViewSnapshot: UIView?

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder: NSCoder) {
        return nil
    }

    @IBAction func onButtonPressed(_ sender: Any) {
        goToGallery()
    }

    override func viewDidLoad() {
    }

    func goToGallery() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PageViewController")
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        imageViewSnapshot = imageView.snapshotView(afterScreenUpdates: false)
        self.present(vc, animated: true, completion: nil)
    }
}

extension StartViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? StartViewController,
                let secondViewController = presented as? PageViewController,
                let imageViewSnapshot = imageViewSnapshot
                else { return nil }

            animator = Animator(type: .present,
                                firstViewController: firstViewController,
                                secondViewController: secondViewController,
                                imageViewSnapshot: imageViewSnapshot)
            return animator
    }


    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? PageViewController,
            let imageViewSnapshot = imageViewSnapshot
            else { return nil }

        animator = Animator(type: .dismiss,
                            firstViewController: self,
                            secondViewController: secondViewController,
                            imageViewSnapshot: imageViewSnapshot)
        return animator
    }
}

