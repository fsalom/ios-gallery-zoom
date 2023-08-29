import UIKit


final class ImageDetailViewModel: NSObject {

    // MARK: - Properties
    var image: UIImage!

    // MARK: - Init
    init(for image: UIImage) {
        self.image = image
    }

}
