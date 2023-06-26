import UIKit

final class SignUpViewController: BaseVC<SignUpViewModel> {

    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.textColor = CheezeAsset.Colors.neutral30.color
        $0.font = CheezeFontFamily.Pretendard.medium.font(size: 13)
    }

    private let inputEmailTextField = InputUserInfoTextField(type: .nomalTextField).then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.setPlaceholder(color: CheezeAsset.Colors.neutral30.color)
        $0.font = CheezeFontFamily.Pretendard.semiBold.font(size: 15)
    }

    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = CheezeAsset.Colors.neutral30.color
        $0.font = CheezeFontFamily.Pretendard.medium.font(size: 13)
    }

    private let inputPasswordTextField = InputUserInfoTextField(type: .nomalTextField).then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.setPlaceholder(color: CheezeAsset.Colors.neutral30.color)
        $0.font = CheezeFontFamily.Pretendard.semiBold.font(size: 15)
    }

    private let signInButton = MainButton()

    private let signUpLabel = UILabel().then {
        $0.text = "이미 Cheeze 회원인가요"
        $0.textColor = CheezeAsset.Colors.neutral30.color
        $0.font = CheezeFontFamily.Pretendard.semiBold.font(size: 13)
    }

    private let pushSignUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = CheezeFontFamily.Pretendard.semiBold.font(size: 13)
        $0.setTitleColor(CheezeAsset.Colors.neutral50.color, for: .normal)
    }

    override func configureVC() {
        navigationItem.title = "회원가입"
    }

    override func addView() {
        view.addSubviews(emailLabel, inputEmailTextField, passwordLabel, inputPasswordTextField,
                         signInButton, signUpLabel, pushSignUpButton)
    }

    override func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }

        inputEmailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextField.snp.bottom).offset(view.bounds.height/25)
            $0.leading.equalToSuperview().offset(20)
        }

        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalToSuperview().dividedBy(14.5)
        }

        signInButton.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(view.bounds.height/25)
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
