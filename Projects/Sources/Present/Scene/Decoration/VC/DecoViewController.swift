import UIKit

final class DecoViewController: BaseVC<DecoViewModel> {
    private let menuType: [String] = ["스티커", "프레임"]

    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = CheezeAsset.Image.sample.image
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
    }

    private lazy var menuTypeSegmentedControl = UISegmentedControl(items: menuType).then {
        $0.backgroundColor = .clear
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                    UIColor.cheezeColor(.neutral(.neutral30)),
                                   .font: CheezeFontFamily.Pretendard.bold.font(size: 15)], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                    UIColor.black,
                                   .font: CheezeFontFamily.Pretendard.bold.font(size: 15)], for: .selected)
    }

    private let oneFrameButton = NormalButtonFrame().then {
        $0.setImage(img: CheezeAsset.Image.oneFrame.image)
    }

    private let fourFrameButton = NormalButtonFrame().then {
        $0.setImage(img: CheezeAsset.Image.fourFrame.image)
    }

    override func configureVC() {
        navigationItem.title = "1/10"
    }

    override func addView() {
        view.addSubviews(mainImageView, menuTypeSegmentedControl, oneFrameButton, fourFrameButton)
    }

    override func setLayout() {
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
        }

        menuTypeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }

        oneFrameButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.top.equalTo(menuTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(74)
        }
        
        fourFrameButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.top.equalTo(menuTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalTo(oneFrameButton.snp.trailing).offset(8)
        }
    }
}
