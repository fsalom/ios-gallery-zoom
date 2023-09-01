//
//  PageViewBuilder.swift
//  ios-gallery
//
//  Created by Fernando Salom Carratala on 30/8/23.
//

import Foundation

final class PagerViewBuilder {
    func build(this images: [String]) -> PagerViewController {
        let pagerController = PagerViewController()
        pagerController.images = images
        return pagerController
    }
}
