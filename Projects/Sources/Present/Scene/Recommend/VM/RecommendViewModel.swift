import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

final class RecommendViewModel: BaseViewModel, Stepper {
    private let newPhotosRelay: BehaviorRelay<[UIImage]>

    let photoList: [UIImage] = [CheezeAsset.Image.hanni.image,
                                CheezeAsset.Image.apple.image,
                                CheezeAsset.Image.gundal.image,
                                CheezeAsset.Image.jungWoo.image,
                                CheezeAsset.Image.jungWookiss.image,
                                CheezeAsset.Image.taebeen.image,
                                CheezeAsset.Image.wany.image,
                                CheezeAsset.Image.ssyy.image,
                                CheezeAsset.Image.sang.image,
                                CheezeAsset.Image.yee.image,
                                CheezeAsset.Image.zza.image,
                                CheezeAsset.Image.haland.image,
                                CheezeAsset.Image.man.image]

    override init() {
        newPhotosRelay = BehaviorRelay(value: photoList)
        super.init()
    }

    var recommendList: Observable<[UIImage]> {
        return newPhotosRelay.asObservable()
    }
}
