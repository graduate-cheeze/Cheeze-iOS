import UIKit

final class NormalButtonFrame: UIButton {
    private let buttonIconImageView = UIImageView()

    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(buttonIconImageView)
        setLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func configureUI() {
        layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.cheezeColor(.neutral(.neutral20)).cgColor
        self.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
    }

    private func setLayout() {
        buttonIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setImage(img: UIImage) {
        self.buttonIconImageView.image = img
    }
}
