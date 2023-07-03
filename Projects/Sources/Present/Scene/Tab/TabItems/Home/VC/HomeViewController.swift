import UIKit
import Photos

final class HomeViewController: BaseVC<HomeViewModel> {
    private let titleLabel = UILabel().then {
        $0.text = """
        곽희상 님,
        안녕하세요 👋
        """
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
    }

    override func configureVC() {
        view.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
    }

    override func addView() {
        view.addSubviews(titleLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.leading.equalToSuperview().offset(18)
        }
    }
}
