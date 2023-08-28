import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct CaptureStepper: Stepper {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return CZStep.captureIsRequired
    }
}

class CaptureFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    var stepper = CaptureStepper()

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else { return .none }
        switch step {
        case .captureIsRequired:
            return captureIsRequired()

        default:
            return .none
        }
    }

    private func captureIsRequired() -> FlowContributors {
        let viewModel = CaptureViewModel()
        let viewController = CaptureViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
