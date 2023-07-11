import UIKit

final class FourFrameView: UIView {
    let firstImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 0
        $0.layer.maskedCorners = .layerMinXMinYCorner
    }

    private let secondImageView = UIImageView().then {
        $0.layer.cornerRadius = 0
        $0.layer.maskedCorners = .layerMaxXMinYCorner
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let thirdImageView = UIImageView().then {
        $0.layer.cornerRadius = 0
        $0.layer.maskedCorners = .layerMinXMaxYCorner
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let fourImageView = UIImageView().then {
        $0.layer.cornerRadius = 0
        $0.layer.maskedCorners = .layerMaxXMaxYCorner
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(firstImageView, secondImageView, thirdImageView, fourImageView)
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
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 10
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(375)
            $0.height.equalTo(444)
        }

        firstImageView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.29)
            $0.height.equalToSuperview().dividedBy(2.65)
            $0.leading.top.equalToSuperview().offset(20)
        }

        secondImageView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.29)
            $0.height.equalToSuperview().dividedBy(2.65)
            $0.trailing.top.equalToSuperview().inset(20)
        }

        thirdImageView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.29)
            $0.height.equalToSuperview().dividedBy(2.65)
            $0.leading.equalTo(firstImageView.snp.leading)
            $0.top.equalTo(firstImageView.snp.bottom).offset(5)
        }

        fourImageView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.29)
            $0.height.equalToSuperview().dividedBy(2.65)
            $0.trailing.equalTo(secondImageView.snp.trailing)
            $0.top.equalTo(secondImageView.snp.bottom).offset(5)
        }
    }

    func setImage(img1: UIImage, img2: UIImage?, img3: UIImage?, img4: UIImage?) {
        firstImageView.image = img1
        secondImageView.image = img2
        thirdImageView.image = img3
        fourImageView.image = img4
    }
}
