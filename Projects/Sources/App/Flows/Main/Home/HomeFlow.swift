import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct HomeStepper: Stepper {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return CZStep.homeIsRequired
    }
}

class HomeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    var stepper = HomeStepper()

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else { return .none }
        switch step {
        case .homeIsRequired:
            return homeIsRequired()
        default:
            return .none
        }
    }

    private func homeIsRequired() -> FlowContributors {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
