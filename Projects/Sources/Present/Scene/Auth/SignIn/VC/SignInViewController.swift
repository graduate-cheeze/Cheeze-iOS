import UIKit

final class SignInViewController: BaseVC<SignInViewModel> {

    private let logoImage = UIImageView().then {
        $0.image = CheezeAsset.Image.logoImage.image
    }

    private let inputEmailTextField = InputUserInfoTextField(type: .emailTextField).then {
        $0.addLeftImage(image: CheezeAsset.Image.emailIcon.image)
        $0.placeholder = "이메일"
    }

    private let inputPasswordTextField = InputUserInfoTextField(type: .secureTextField).then {
        $0.addLeftImage(image: CheezeAsset.Image.pwIcon.image)
        $0.placeholder = "비밀번호"
    }

    private let findPassword = UIButton().then {
        $0.titleLabel?.font = CheezeFontFamily.Pretendard.semiBold.font(size: 13)
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(CheezeAsset.Colors.neutral50.color, for: .normal)
    }

    private let signInButton = MainButton()

    private let signUpLabel = UILabel().then {
        $0.text = "Cheeze가 처음인가요?"
        $0.textColor = CheezeAsset.Colors.neutral30.color
        $0.font = CheezeFontFamily.Pretendard.semiBold.font(size: 13)
    }

    private let pushSignUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = CheezeFontFamily.Pretendard.semiBold.font(size: 13)
        $0.setTitleColor(CheezeAsset.Colors.neutral50.color, for: .normal)
    }

    private func bindViewModel() {
        let input = SignInViewModel.Input(
            decoButtonTap: signInButton.mainButton.rx.tap.asObservable()
        )
        let output = viewModel.transVC(input: input)
    }

    override func configureVC() {
        bindViewModel()
    }

    override func addView() {
        view.addSubviews(logoImage, inputEmailTextField, inputPasswordTextField,
                         signInButton, findPassword, signUpLabel, pushSignUpButton)
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.bounds.height/15.6)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(7.25)
            $0.width.equalToSuperview().dividedBy(2.5)
        }

        inputEmailTextField.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(view.bounds.height/25.3)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        findPassword.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }

        signInButton.snp.makeConstraints {
            $0.top.equalTo(findPassword.snp.bottom).offset(view.bounds.height/25)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(99)
        }

        pushSignUpButton.snp.makeConstraints {
            $0.centerY.equalTo(signUpLabel)
            $0.leading.equalTo(signUpLabel.snp.trailing).offset(8)
        }
    }
}
