import UIKit

final class IntroVC: BaseVC<IntroVM> {

    private let logoImage = UIImageView().then {
        $0.image = CheezeAsset.Image.logoImage.image
    }

    private let pushSignUpButton = MainButton().then {
        $0.setTitle(text: "회원가입")
    }

    private let pushSignInButton = UIButton().then {
        $0.titleLabel?.font = CheezeFontFamily.Pretendard.bold.font(size: 16)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor.cheezeColor(.neutral(.neutral50)), for: .normal)
    }

    override func addView() {
        view.addSubviews(logoImage, pushSignUpButton, pushSignInButton)
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(bounds.height/3.2)
            $0.leading.trailing.equalToSuperview().inset(113)
            $0.height.equalToSuperview().dividedBy(7.25)
            $0.width.equalToSuperview().dividedBy(2.5)
        }

        pushSignUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(83)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        pushSignInButton.snp.makeConstraints {
            $0.top.equalTo(pushSignUpButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
