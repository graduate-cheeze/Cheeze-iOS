import UIKit

protocol StickerObjectViewDelegate: AnyObject {
    func stickerObjectViewDidPan(_ view: StickerObjectView, _ gesture: UIPanGestureRecognizer)
    func stickerObjectViewDidRotate(_ view: StickerObjectView, _ gesture: UIRotationGestureRecognizer)
    func stickerObjectViewDidPinch(_ view: StickerObjectView, _ gesture: UIPinchGestureRecognizer)
    func stickerObjectViewDidDoubleTap(_ view: StickerObjectView)
}

class StickerObjectView: UIImageView {
    weak var delegate: StickerObjectViewDelegate?

    private var panGesture: UIPanGestureRecognizer!
    private var rotationGesture: UIRotationGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!

    init(image: UIImage) {
        super.init(frame: .zero)
        self.image = image
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestures() {
        // Pan gesture
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        self.addGestureRecognizer(panGesture)

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

    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        delegate?.stickerObjectViewDidPan(self, gesture)
    }

    @objc private func rotationGestureHandler(_ gesture: UIRotationGestureRecognizer) {
        delegate?.stickerObjectViewDidRotate(self, gesture)
    }

    @objc private func pinchGestureHandler(_ gesture: UIPinchGestureRecognizer) {
        delegate?.stickerObjectViewDidPinch(self, gesture)
    }

    @objc private func doubleTapGestureHandler(_ gesture: UITapGestureRecognizer) {
        delegate?.stickerObjectViewDidDoubleTap(self)
    }
}
