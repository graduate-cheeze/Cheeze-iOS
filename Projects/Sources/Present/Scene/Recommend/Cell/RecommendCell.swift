import UIKit
import Then
import SnapKit
import Kingfisher

final class RecommendCell: UICollectionViewCell {
    static let identifier = "RecommendCell"

    let mainImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
        addView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        self.addSubviews(mainImageView)
    }

    private func setLayout() {
        mainImageView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
}
