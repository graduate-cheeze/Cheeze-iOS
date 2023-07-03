import UIKit

extension UIView {
    func addSubviews(_ subView: UIView...) {
        subView.forEach(addSubview(_:))
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
