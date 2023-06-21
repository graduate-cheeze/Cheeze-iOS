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

        clear()

        self.rightView = clearButton
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.backgroundColor = CheezeAsset.Colors.neutral10.color
    }

    private func clear() {
        clearButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.text = ""
            }.disposed(by: disposeBag)
    }
}
