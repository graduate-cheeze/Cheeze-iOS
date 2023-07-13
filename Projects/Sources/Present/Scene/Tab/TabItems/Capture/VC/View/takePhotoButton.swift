import UIKit
import SnapKit
import Then

final class TakePhotoButton: UIView {
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(mainButton)
        configureUI()
        setLayout()
    }

    let mainButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 35
        $0.layer.borderColor = CheezeAsset.Colors.primaryColor2.color.cgColor
        $0.layer.borderWidth = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setLayout() {
        mainButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(72)
        }
    }

    // MARK: - Helpers
    private func configureUI() {
        self.layer.cornerRadius = 40
        self.layer.borderWidth = 5
        self.layer.borderColor = CheezeAsset.Colors.primaryColor1.color.cgColor
    }
}
