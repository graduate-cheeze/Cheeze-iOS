import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

final class DecoViewModel: BaseViewModel, Stepper {
    private let selectedPhotosRelay: BehaviorRelay<[PHAsset]>

    init(selectedPhotos: [PHAsset]) {
        selectedPhotosRelay = BehaviorRelay(value: selectedPhotos)
        super.init()
    }

    struct Input {

    }

    struct Output {
    }

    var selectedPhotos: Observable<[UIImage]> {
        return selectedPhotosRelay.asObservable()
            .flatMapLatest { assets -> Observable<[UIImage]> in
                let imageRequests = assets.map { self.requestImage(for: $0) }
                return Observable.combineLatest(imageRequests)
            }
    }

    func requestImage(for asset: PHAsset) -> Observable<UIImage> {
        return Observable.create { observer in
            let options = PHImageRequestOptions()
            options.isSynchronous = true

            PHImageManager.default().requestImageData(for: asset, options: options) { imageData, _, _, _ in
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    observer.onNext(image)
                } else {
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    func transVC(input: Input) -> Output {
        return Output()
    }
}
