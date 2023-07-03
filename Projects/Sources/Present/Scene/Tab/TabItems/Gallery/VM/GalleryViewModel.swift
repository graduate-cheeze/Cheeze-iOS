import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

final class GalleryViewModel: BaseViewModel, Stepper {

    struct Input {
        let completeButtonTap: Observable<Void>
    }

    struct Output {
    }

    private let selectedPhotosRelay = BehaviorRelay<[PHAsset]>(value: [])

    func transVC(input: Input) -> Output {
        input.completeButtonTap.subscribe(
            onNext: { _ in
                self.pushDecoVC()
            }
        ) .disposed(by: disposeBag)

        return Output()
    }

    private func pushDecoVC() {
        let selectedPhotos = selectedPhotosRelay.value
        self.steps.accept(CZStep.decoIsRequired(selectedPhotos))
    }

    func updateSelectedPhotos(_ photos: [PHAsset]) {
        selectedPhotosRelay.accept(photos)
        print(photos)
    }
}
