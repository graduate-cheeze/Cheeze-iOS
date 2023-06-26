import UIKit

extension UITextField {
    func addLeftImage(image: UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        leftImage.image = image
        self.leftView = leftImage
        self.leftViewMode = .always
    }

    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}
