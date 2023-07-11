import UIKit
import Then
import SnapKit
import Kingfisher

final class StickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "StickerCell"

    let stickerButtonView = NormalButtonFrame().then {
        $0.isEnabled = false
    }

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
        self.addSubviews(stickerButtonView)
    }

    private func setLayout() {
        stickerButtonView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
}
