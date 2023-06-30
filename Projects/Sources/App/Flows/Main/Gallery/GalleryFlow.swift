import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct GalleryStepper: Stepper {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return CZStep.galleryIsRequired
    }
}

class GalleryFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    var stepper = GalleryStepper()

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else { return .none }
        switch step {
        case .galleryIsRequired:
            return galleryIsRequired()

        default:
            return .none
        }
    }

    private func galleryIsRequired() -> FlowContributors {
        let viewModel = GalleryViewModel()
        let viewController = GalleryViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
