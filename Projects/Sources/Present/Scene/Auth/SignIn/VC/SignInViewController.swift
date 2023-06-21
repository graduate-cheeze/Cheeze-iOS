import UIKit

final class SignInViewController: BaseVC<SignInViewModel> {

    private let logoImage = UIImageView().then {
        $0.image = CheezeAsset.Image.logoImage.image
    }

    private let inputEmailTextField = InputUserInfoTextField().then {
        $0.placeholder = "이메일"
    }

    override func addView() {
        view.addSubviews(logoImage, inputEmailTextField)
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(65)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(7.25)
            $0.width.equalToSuperview().dividedBy(2.5)
        }

        inputEmailTextField.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }
    }
}
