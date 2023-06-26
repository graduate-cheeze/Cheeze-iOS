import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class IntroVM: BaseViewModel, Stepper {

    struct Input {
        let signInButtonTap: Observable<Void>
        let signUpButtonTap: Observable<Void>
    }

    struct Output {

    }

    func transVC(input: Input) -> Output {
        input.signInButtonTap.subscribe(
            onNext: { _ in
                self.pushSignInVC()
            }
        ) .disposed(by: disposeBag)

        input.signUpButtonTap.subscribe(
            onNext: { _ in
                self.pushSignUpVC()
            }
        ).disposed(by: disposeBag)
        return Output()
    }

    private func pushSignInVC() {
        self.steps.accept(CZStep.signInIsRequired)
    }

    private func pushSignUpVC() {
        self.steps.accept(CZStep.signUpIsRequired)
    }
}
