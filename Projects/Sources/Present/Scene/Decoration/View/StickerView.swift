import UIKit

class StickerObjectView: UIImageView {
    private var panGesture: UIPanGestureRecognizer!
    private var rotationGesture: UIRotationGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!

    init(image: UIImage) {
        super.init(frame: .zero)
        self.image = image
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        setupGestures()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestures() {
        // Rotation gesture
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(_:)))
        self.addGestureRecognizer(rotationGesture)

        // Pinch gesture
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler(_:)))
        self.addGestureRecognizer(pinchGesture)

        // Double tap gesture
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureHandler(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)

        // Enable user interaction
        self.isUserInteractionEnabled = true
    }

    @objc func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        let changedX = self.center.x + translation.x
        let changedY = self.center.y + translation.y

        self.center = CGPoint(x: changedX, y: changedY)

        gesture.setTranslation(.zero, in: self)
    }

    @objc private func rotationGestureHandler(_ gesture: UIRotationGestureRecognizer) {
        self.transform = self.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }

    @objc private func pinchGestureHandler(_ gesture: UIPinchGestureRecognizer) {
        self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }

    @objc private func doubleTapGestureHandler(_ gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
}
