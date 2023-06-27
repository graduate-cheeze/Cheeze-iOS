import UIKit

final class ButtonContainer: UIView {
    let oneFrameButton = NormalButtonFrame().then {
        $0.setImage(img: CheezeAsset.Image.oneFrame.image)
    }

    let fourFrameButton = NormalButtonFrame().then {
        $0.setImage(img: CheezeAsset.Image.fourFrame.image)
    }

    let xButton = NormalButtonFrame().then {
        $0.setImage(img: CheezeAsset.Image.xBtn.image)
    }

    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(oneFrameButton, fourFrameButton, xButton)
        setLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func configureUI() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.cheezeColor(.neutral(.neutral20)).cgColor
        self.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
    }

    private func setLayout() {
        oneFrameButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview()
        }

        fourFrameButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalTo(oneFrameButton.snp.trailing).offset(8)
        }

        xButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalTo(fourFrameButton.snp.trailing).offset(8)
        }
    }
}
