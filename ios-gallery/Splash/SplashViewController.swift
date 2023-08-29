//
//  ImageDetailViewController.swift
//  RudoApp
//
//  Created by Jorge Planells on 17/2/23.
//  Copyright © 2023 Rudo. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageViewSnapshot = UIImageView()

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Functions

    func setupUI() {
        self.view.backgroundColor = .black
    }
}
