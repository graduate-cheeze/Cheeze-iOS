import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

final class RecommendViewModel: BaseViewModel, Stepper {
    private let newPhotosRelay: BehaviorRelay<[UIImage]>

    let photoList: [UIImage] = [CheezeAsset.Image.hanni.image,
                                CheezeAsset.Image.haland.image,
                                CheezeAsset.Image.bBang1.image,
                                CheezeAsset.Image.bBang2.image,
                                CheezeAsset.Image.ock1.image,
                                CheezeAsset.Image.ock2.image,
                                CheezeAsset.Image.man.image,
                                CheezeAsset.Image.wany.image]

    override init() {
        newPhotosRelay = BehaviorRelay(value: photoList)
        super.init()
    }

    var recommendList: Observable<[UIImage]> {
        return newPhotosRelay.asObservable()
    }
}
