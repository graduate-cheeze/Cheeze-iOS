import UIKit

final class MainTapBarViewController: UITabBarController {
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI
private extension MainTapBarViewController {
    func configureVC() {
        UITabBar.clearShadow()
        tabBar.backgroundColor = .white

        tabBar.layer.cornerRadius = tabBar.frame.height * 0.21
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = .black
    }
}
