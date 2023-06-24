import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class InputUserInfoTextField: UITextField {
    private let disposeBag = DisposeBag()

    var type: TextFieldType = .normalTextField

    private let clearButton = UIButton().then {
        $0.setImage(CheezeAsset.Image.xmarkIcon.image, for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    convenience init(type: TextFieldType) {
        self.init()
        self.type = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self

        clear()

        self.font = CheezeFontFamily.Pretendard.semiBold.font(size: 15)
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
        self.layer.cornerRadius = 20
        self.backgroundColor = CheezeAsset.Colors.neutral10.color
    }

    private func clear() {
        clearButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.text = ""
            }.disposed(by: disposeBag)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 16

        return padding
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.leftViewRect(forBounds: bounds)
        padding.origin.x += 16

        return padding
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = super.textRect(forBounds: bounds)
        let rightViewWidth: CGFloat = rightView?.bounds.width ?? 0
        let spacing: CGFloat = 10

        let newPadding = CGRect(x: padding.origin.x+10, y: padding.origin.y,
                                width: padding.width - rightViewWidth - spacing, height: padding.height)

        return newPadding
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension InputUserInfoTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = CheezeAsset.Colors.neutral50.color.cgColor

        switch self.type {
        case .normalTextField:
            textField.addLeftImage(image: CheezeAsset.Image.emailIconFill.image)
        case .secureTextField:
            textField.addLeftImage(image: CheezeAsset.Image.pwIconFill.image)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor

        switch self.type {
        case .normalTextField:
            textField.addLeftImage(image: CheezeAsset.Image.emailIcon.image)
        case .secureTextField:
            textField.addLeftImage(image: CheezeAsset.Image.pwIcon.image)
        }
    }
}
