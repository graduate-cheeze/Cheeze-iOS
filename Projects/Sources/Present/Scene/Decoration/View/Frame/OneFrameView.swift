import UIKit

final class OneFrameView: UIView {
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(mainImageView)
        setLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(375)
            $0.height.equalTo(444)
        }

        mainImageView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview().inset(20)
        }
    }

    func setImage(img: UIImage) {
        mainImageView.image = img
    }
}
