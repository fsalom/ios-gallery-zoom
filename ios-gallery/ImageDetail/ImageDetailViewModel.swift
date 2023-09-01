import UIKit


final class ImageDetailViewModel {
    // MARK: - Properties
    var data: Data? = nil
    var didDownloadImage: (() -> Void)?

    // MARK: - Inita
    init(for url: String) {
        Task {
            guard let urlImage = URL(string: url) else { return }
            self.data = try? await downloadImageData(from: urlImage)
            self.didDownloadImage?()
        }
    }

    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
