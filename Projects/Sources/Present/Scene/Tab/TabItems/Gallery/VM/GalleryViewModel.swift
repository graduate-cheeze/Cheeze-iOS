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
            }
        ) .disposed(by: disposeBag)

        return Output()
    }

    func updateSelectedPhotos(_ photos: [PHAsset]) {
        selectedPhotosRelay.accept(photos)
        print(photos)
    }
}
