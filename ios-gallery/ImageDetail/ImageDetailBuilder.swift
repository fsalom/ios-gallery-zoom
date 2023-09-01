//
//  ImageDetailBuilder.swift
//  RudoApp
//
//  Created by Jorge Planells on 17/2/23.
//  Copyright © 2023 Rudo. All rights reserved.
//

import UIKit

enum ImageDetailState {
    case uploadNewPhoto
    case showMenu
    case viewer
}

final class ImageDetailBuilder {
    func build(this url: String, delegate: PagerControlProtocol) -> ImageDetailViewController {
        let viewController = ImageDetailViewController()
        viewController.delegate = delegate
        let viewModel = ImageDetailViewModel(for: url)
        viewController.viewModel = viewModel
        return viewController
    }
}
