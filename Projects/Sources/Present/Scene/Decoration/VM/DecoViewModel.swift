import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

final class DecoViewModel: BaseViewModel, Stepper {
    private let selectedPhotosRelay: BehaviorRelay<[PHAsset]>
    private let newPhotosRelay: BehaviorRelay<[UIImage]>

    let iconList: [UIImage] = [CheezeAsset.Image.cheezelogo.image,
                               CheezeAsset.Image.skateboard.image,
                               CheezeAsset.Image.sparkle.image,
                               CheezeAsset.Image.sunglasses.image,
                               CheezeAsset.Image.voltage.image,
                               CheezeAsset.Image.thumbsUp.image,
                               CheezeAsset.Image.leg.image,
                               CheezeAsset.Image.gesture.image,
                               CheezeAsset.Image.music.image]

    init(selectedPhotos: [PHAsset]) {
        selectedPhotosRelay = BehaviorRelay(value: selectedPhotos)
        newPhotosRelay = BehaviorRelay(value: iconList)
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

    var photosList: Observable<[UIImage]> {
        return newPhotosRelay.asObservable()
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
