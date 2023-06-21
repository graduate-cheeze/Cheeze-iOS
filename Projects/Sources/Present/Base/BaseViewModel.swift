import UIKit
import RxSwift
import RxCocoa
import RxFlow

class BaseViewModel {
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
}
