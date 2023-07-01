import UIKit
import RxSwift
import RxCocoa
import RxFlow

final class GalleryViewModel: BaseViewModel, Stepper {

    struct Input {
        let completeButtonTap: Observable<Void>
    }

    struct Output {

    }

    func transVC(input: Input) -> Output {
        input.completeButtonTap.subscribe(
            onNext: { _ in
                self.pushDecoVC()
            }
        ) .disposed(by: disposeBag)
        return Output()
    }

    private func pushDecoVC() {
        self.steps.accept(CZStep.decoIsRequired)
    }
}
