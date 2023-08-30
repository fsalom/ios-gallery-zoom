//
//  StartController.swift
//  ios-gallery
//
//  Created by Fernando Salom Carratala on 22/8/23.
//

import Foundation
import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

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
        self.present(vc, animated: false, completion: nil)
    }
}

