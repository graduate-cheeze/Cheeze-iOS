import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class SignInViewModel: BaseViewModel, Stepper {
    struct Input {
        let decoButtonTap: Observable<Void>
    }

    struct Output {

    }

    func transVC(input: Input) -> Output {
        input.decoButtonTap.subscribe(
            onNext: { _ in
                self.pushDecoVC()
            }
        ) .disposed(by: disposeBag)
        return Output()
    }

    private func pushSignInVC() {
        self.steps.accept(CZStep.signInIsRequired)
    }

    private func pushDecoVC() {
        self.steps.accept(CZStep.galleryIsRequired)
    }
}
