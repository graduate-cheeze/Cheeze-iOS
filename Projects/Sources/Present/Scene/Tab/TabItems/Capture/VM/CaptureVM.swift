import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class CaptureViewModel: BaseViewModel, Stepper {
    struct Input {
    }

    struct Output {
    }

    func transVC(input: Input) -> Output {
        return Output()
    }

    private func pushRecommendVC() {
        self.steps.accept(CZStep.recommendIsRequired)
    }
}
