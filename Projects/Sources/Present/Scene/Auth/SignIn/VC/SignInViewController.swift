import UIKit

final class SignInViewController: BaseVC<SignInViewModel> {

    private let logoImage = UIImageView().then {
        $0.image = CheezeAsset.Image.logoImage.image
    }

    private let emailImage = UIImageView().then {
        $0.image = CheezeAsset.Image.emailIcon.image
    }

    override func addView() {
        view.addSubview(logoImage)
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(65)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(7.25)
            $0.width.equalToSuperview().dividedBy(2.5)
        }
    }
}
