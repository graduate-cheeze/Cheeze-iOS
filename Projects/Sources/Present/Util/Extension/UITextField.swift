import UIKit

extension UITextField {
    func addLeftImage(image: UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        leftImage.image = image
        self.leftView = leftImage
        self.leftViewMode = .always
    }
}
