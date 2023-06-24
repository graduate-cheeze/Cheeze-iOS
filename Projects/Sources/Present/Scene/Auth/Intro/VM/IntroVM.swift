import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class IntroVM: BaseViewModel, Stepper {

    struct Input {
        let signInButtonTap: Observable<Void>
    }

    struct Output {

    }

    func transVC(input: Input) -> Output {
        input.signInButtonTap.subscribe(
            onNext: { _ in
                self.pushSignInVC()
            }
        ) .disposed(by: disposeBag)
        return Output()
    }

    private func pushSignInVC() {
        self.steps.accept(CZStep.signInIsRequired)
    }
}
