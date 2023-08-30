//
//  ImageDetailViewController.swift
//  RudoApp
//
//  Created by Jorge Planells on 17/2/23.
//  Copyright © 2023 Rudo. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var imageURL: String!
    var viewModel: ImageDetailViewModel!
    var delegate: PagerControlProtocol!
    var beginLocation: CGPoint = CGPoint(x: 0, y: 0)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    // MARK: - Functions
    func setupUI() {
        self.view.backgroundColor = .black
        self.scrollView.delegate = self
        self.imageView.image = viewModel.image
        self.imageView.frame = CGRect(x: self.imageView.frame.origin.x,
                                      y: self.imageView.frame.origin.y,
                                      width: viewModel.image.size.width,
                                      height: viewModel.image.size.height)
        addGesture()
    }

    func addGesture() {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        tapGesture.require(toFail: doubleTap)
        imageView.addGestureRecognizer(doubleTap)
        let panGesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(pan(_ :)))
        imageView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //setupAnimation()
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.scrollView)
        imageView.center.y = location.y
        if gesture.state == .began {
            beginLocation = location
        }
        if gesture.state == .ended {
            if gesture.velocity(in: self.scrollView).y < -100 {
                if beginLocation.y - location.y > 200 {
                    self.delegate.dismissPager()
                    return
                }
            }

            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [.curveEaseOut, .allowUserInteraction]) {
                self.imageView.center.y = self.scrollView.center.y
                self.view.layer.opacity = 1
            }
        }

        if gesture.state == .changed {
            let midHeight = (self.view.frame.height / 2)

            if location.y < midHeight {
                let opacity =  1 - (midHeight - location.y) / (self.view.frame.height / 2)
                self.view.layer.opacity = Float(opacity) + 0.7
            }

            if location.y > midHeight {
                let opacity =  1 - (location.y - midHeight) / (self.view.frame.height / 2)
                self.view.layer.opacity = Float(opacity) + 0.7
            }
        }
    }

    func setupAnimation() {
        let isBlack = self.view.backgroundColor == .black
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            self.view.backgroundColor = isBlack ? .white : .black
            self.navigationController?.navigationBar.isHidden = !isBlack
            self.tabBarController?.tabBar.isHidden = !isBlack
        }
    }

    @objc func doubleTapped(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: self.imageView)
        var newZoomScale = self.scrollView.maximumZoomScale
        delegate.disablePager()

        if self.scrollView.zoomScale >= newZoomScale || abs(self.scrollView.zoomScale - newZoomScale) <= 0.01 {
            delegate.enablePager()
            newZoomScale = self.scrollView.minimumZoomScale
        }

        let width = self.scrollView.bounds.width / newZoomScale
        let height = self.scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.scrollView.zoom(to: rectToZoomTo, animated: true)
    }

    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        delegate.disablePager()

        if self.scrollView.zoomScale > self.scrollView.maximumZoomScale {
            return
        }
        let yOffset = (self.view.safeAreaLayoutGuide.layoutFrame.size.height - imageView.frame.height) / 2 + 40

        imageViewTopConstraint.constant = yOffset

        view.layoutIfNeeded()

        if scrollView.contentOffset.x == 0 && scrollView.contentOffset.y == 0 {
            delegate.enablePager()
        }
    }

    fileprivate func updateZoomScaleForSize(_ size: CGSize) {
        //print("updateZoomScaleForSize")
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 3
    }
}

extension ImageDetailViewController: UIGestureRecognizerDelegate {


}

// MARK: - ScrollView delegate
extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }
}

