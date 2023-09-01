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
        let images = ["https://c02.purpledshub.com/uploads/sites/41/2021/08/mountains-7ddde89.jpg", "https://c02.purpledshub.com/uploads/sites/41/2021/08/mountains-7ddde89.jpg", "https://c02.purpledshub.com/uploads/sites/41/2021/08/mountains-7ddde89.jpg"]
        let pager = PagerViewBuilder().build(this: images)

        pager.modalPresentationStyle = .custom
        self.present(pager, animated: false, completion: nil)
    }
}

