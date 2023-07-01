import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit

class GalleryCell: UICollectionViewCell {
    static let identifier = "GalleryCell"
    private(set) var disposeBag = DisposeBag()

    // 셀의 UI 요소들을 선언합니다.
    let imageView = UIImageView()

    private let blackView = UIView()

    private let cellNumberLabel = UILabel().then {
        $0.textColor = UIColor.cheezeColor(.primary(.primary3))
        $0.font = CheezeFontFamily.Pretendard.bold.font(size: 32)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(imageView, blackView, cellNumberLabel)

        blackView.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.6)
        blackView.isHidden = true
        imageView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setLayout()
    }

    override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag() // 이전의 구독을 폐기
    }

    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }

        blackView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }

        cellNumberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func changeColor(num: String, hidden: Bool) {
        blackView.isHidden = hidden
        cellNumberLabel.text = num
    }

    // 셀의 데이터를 설정하는 메서드
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
