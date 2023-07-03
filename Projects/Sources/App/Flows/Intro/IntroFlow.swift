import RxFlow
import UIKit
import RxCocoa
import RxSwift

struct IntroStepper: Stepper {
    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return CZStep.introIsRequired
    }
}

class IntroFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    var stepper = IntroStepper()

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else { return .none }
        switch step {
        case .introIsRequired:
            return introIsRequired()
        case .signInIsRequired:
            return signInIsRequired()
        case .signUpIsRequired:
            return signUpIsRequired()
        case .tabBarIsRequired:
            return .end(forwardToParentFlowWithStep: CZStep.tabBarIsRequired)
        default:
            return .none
        }
    }

    private func introIsRequired() -> FlowContributors {
        let viewModel = IntroVM()
        let viewController = IntroVC(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    private func signInIsRequired() -> FlowContributors {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    private func signUpIsRequired() -> FlowContributors {
        let viewModel = SignUpViewModel()
        let viewController = SignUpViewController(viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
