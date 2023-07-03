import RxFlow
import Photos
import UIKit
import RxCocoa
import RxSwift

struct GalleryStepper: Stepper {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return CZStep.galleryIsRequired
    }

    enum GalleryStep: Step {
        case selectedPhotos([PHAsset])
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
        case .decoIsRequired(let selectedPhotos):
            return decoIsRequired(selectedPhotos: selectedPhotos)

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

    private func decoIsRequired(selectedPhotos: [PHAsset]) -> FlowContributors {
        let viewModel = DecoViewModel(selectedPhotos: selectedPhotos)
        let viewController = DecoViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
     }
}
