import UIKit


final class ImageDetailViewModel {
    // MARK: - Properties
    var url: String
    var data: Data? {
        didSet {
            didDownloadImage?()
            print("Finish - didDownloadImage")
        }
    }
    var didDownloadImage: (() -> Void)?

    // MARK: - Inita
    init(for url: String) {
        self.url = url
        load()
    }

    func load() {
        Task {
            guard let urlImage = URL(string: url) else { return }
            guard let _ = data else {
                self.data = try? await downloadImageData(from: urlImage)
                return
            }
            didDownloadImage?()
        }
    }
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
