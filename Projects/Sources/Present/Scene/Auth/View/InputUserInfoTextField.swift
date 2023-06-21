import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class InputUserInfoTextField: UITextField {
    var type: TextFieldType = .normalTextField

    convenience init(type: TextFieldType) {
        self.init()
        self.type = type

    }
}
