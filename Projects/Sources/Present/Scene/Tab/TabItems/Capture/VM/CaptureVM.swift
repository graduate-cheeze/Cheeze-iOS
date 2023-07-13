import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class CaptureViewModel: BaseViewModel, Stepper {
    struct Input {
        let recommendButtonTap: Observable<Void>
    }

    struct Output {
    }

    func transVC(input: Input) -> Output {
        input.recommendButtonTap.subscribe(
            onNext: { _ in
                self.pushRecommendVC()
            }
        ) .disposed(by: disposeBag)

        return Output()
    }

    private func pushRecommendVC() {
        self.steps.accept(CZStep.recommendIsRequired)
    }
}
