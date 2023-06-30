import RxFlow
import UIKit
import RxCocoa
import RxSwift

final class TabBarFlow: Flow {

    enum TabBarIndex: Int {
        case gallery = 0
        case capture = 1
    }

    var root: Presentable {
        return self.rootVC
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    private let rootVC = MainTapBarViewController()

    private var homeFlow = HomeFlow()
    private var galleryFlow = GalleryFlow()
    private var captureFlow = CaptureFlow()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else {return .none}

        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar(index: 0)
        default:
            return .none
        }
    }

}

private extension TabBarFlow {
    func coordinateToTabbar(index: Int) -> FlowContributors {
        Flows.use(
            homeFlow, galleryFlow, captureFlow,
            when: .ready
        ) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController) in

            let homeItem = UITabBarItem(
                title: "홈",
                image: CheezeAsset.Image.tabBarHome.image.withRenderingMode(.alwaysOriginal),
                selectedImage: CheezeAsset.Image.tabBarHomeFill.image.withRenderingMode(.alwaysOriginal)
            )

            let newsItem = UITabBarItem(
                title: "갤러리",
                image: CheezeAsset.Image.tabBarGallery.image.withRenderingMode(.alwaysOriginal),
                selectedImage: CheezeAsset.Image.tabBarGalleryFill.image.withRenderingMode(.alwaysOriginal)
            )

            let leagueItem = UITabBarItem(
                title: "찍기",
                image: CheezeAsset.Image.tabBarCamera.image.withRenderingMode(.alwaysOriginal),
                selectedImage: CheezeAsset.Image.tabBarCameraFill.image.withRenderingMode(.alwaysOriginal)
            )

            root1.tabBarItem = homeItem
            root2.tabBarItem = newsItem
            root3.tabBarItem = leagueItem

            self.rootVC.setViewControllers([root1, root2, root3], animated: true)
            self.rootVC.selectedIndex = index
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: homeFlow.stepper),
            .contribute(withNextPresentable: galleryFlow, withNextStepper: galleryFlow.stepper),
            .contribute(withNextPresentable: captureFlow, withNextStepper: captureFlow.stepper)
        ])
    }
}
