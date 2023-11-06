import UIKit

public enum ShareToInstagram {
    public static func shareToInstaStories(detailPostView: UIView, completion: @escaping () -> Void) {
        let renderer = UIGraphicsImageRenderer(bounds: detailPostView.bounds)

        let saveImage = renderer.image { context in
            detailPostView.layer.render(in: context.cgContext)
        }

        let appID = "Cheeze"
        let backgroundImage = CheezeAsset.Image.background.image
        
        if let storiesUrl = URL(string: "instagram-stories://share?source_application=\(appID)") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let imageData = saveImage.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundImage" : backgroundImage
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                completion()
            }
        }
    }
}
