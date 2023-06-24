import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    init() {}

    func readyToEmitSteps() {
        Observable.just(CZStep.introIsRequired)
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

final class AppFlow: Flow {

    var root: Presentable {
        return window
    }

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CZStep else {return .none}

        switch step {
        case .introIsRequired:
            return coordinateToIntro()
        default:
            return .none
        }
    }
}

private extension AppFlow {
    func coordinateToIntro() -> FlowContributors {
        let flow = IntroFlow()
        Flows.use(flow,
                  when: .created) { [unowned self] root in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: flow,
            withNextStepper: OneStepper(withSingleStep:
                                            CZStep.introIsRequired)))
    }
}
