import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class SignInViewModel: BaseViewModel, Stepper {
    func transVC(decoButtonTap: Observable<Void>) {
        decoButtonTap.subscribe(
            onNext: { _ in
                self.pushDecoVC()
            }
        ) .disposed(by: disposeBag)
    }

    private func pushSignInVC() {
        self.steps.accept(CZStep.signInIsRequired)
    }

    private func pushDecoVC() {
        self.steps.accept(CZStep.tabBarIsRequired)
    }
}
