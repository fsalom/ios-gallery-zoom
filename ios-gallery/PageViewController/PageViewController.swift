//
//  ViewController.swift
//  ios-gallery
//
//  Created by Fernando Salom Carratala on 22/8/23.
//

import UIKit

protocol PagerControlProtocol {
    func disablePager()
    func enablePager()
    func dismissPager()
}

class PagerViewController: UIPageViewController {
    public var images = [String]()
    public var initialIndex = 1
    var pageViewController : UIPageViewController?
    fileprivate var items: [UIViewController] = []
    var imageView = UIImageView()

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        setupUI()
        enableSwipeGesture()
    }

    func setupPager() {
        for image in images {
            items.append(ImageDetailBuilder().build(this: image, delegate: self))
        }

        self.setViewControllers([items[initialIndex]],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        self.dataSource = self
        self.delegate = self
    }

    func setupUI() {
        self.view.backgroundColor = .black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func disableSwipeGesture(){
        DispatchQueue.main.async {
            for view in self.view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = false
                }
            }
        }
    }

    func enableSwipeGesture(){
        DispatchQueue.main.async {
            for view in self.view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = true
                }
            }
        }
    }
}

extension PagerViewController:  UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.items.firstIndex(of: viewController) {
               if viewControllerIndex == 0 {
                   return nil
               } else {
                   return self.items[viewControllerIndex - 1]
               }
           }
           return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.items.firstIndex(of: viewController) {
                if viewControllerIndex < self.items.count - 1 {
                    return self.items[viewControllerIndex + 1]
                } else {
                    return nil
                }
            }
            return nil
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.items.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }

        return firstViewControllerIndex
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension PagerViewController: PagerControlProtocol {
    func disablePager() {
        disableSwipeGesture()
    }
    
    func enablePager() {
        enableSwipeGesture()
    }
    
    func dismissPager() {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: [.curveEaseOut]) {
            self.view.isOpaque = false
            self.view.layer.opacity = 0
            self.dismiss(animated: false)
        }

    }
}


