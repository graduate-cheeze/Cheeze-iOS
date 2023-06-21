import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    private let viewBounds = UIScreen.main.bounds

    private let logoImage = UIImageView().then {
        $0.image = CheezeAsset.Image.logoImage.image
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        addView()
        setLayout()
    }

    func addView() {
        view.addSubview(logoImage)
    }

    func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(65)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(7.25)
            $0.width.equalToSuperview().dividedBy(2.5)
        }
    }
}
