import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class BaseVC<T: BaseViewModel>: UIViewController {
    let viewModel: T
    var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds

    init(_ viewModel: T) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white

        addView()
        setLayout()
        configureVC()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func addView() {}
    func setLayout() {}
    func configureVC() {}
}
