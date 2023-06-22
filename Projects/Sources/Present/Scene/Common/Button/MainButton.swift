import UIKit
import SnapKit
import Then
import Gradients

final class MainButton: UIView {
    // MARK: - Properties
    private let viewBounds = UIScreen.main.bounds

    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviews(mainButton)
        configureUI()
        setLayout()
    }

    private let mainButton = UIButton().then {
        $0.backgroundColor = CheezeAsset.Colors.primaryColor2.color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = CheezeFontFamily.Pretendard.bold.font(size: 16)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }

    lazy var innerShadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowColor = UIColor.rgba(red: 255, green: 255, blue: 255, alpha: 0.6).cgColor
        shadowLayer.shadowOffset = CGSize(width: 5, height: 5)
        shadowLayer.shadowOpacity = 5
        shadowLayer.shadowRadius = 5
        shadowLayer.fillRule = .evenOdd
        return shadowLayer
    }()

    lazy var innerShadowSubLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowColor = UIColor.rgba(red: 174, green: 94, blue: 0, alpha: 0.1).cgColor
        shadowLayer.shadowOffset = CGSize(width: -6, height: -6)
        shadowLayer.shadowOpacity = 5
        shadowLayer.shadowRadius = 20
        shadowLayer.fillRule = .evenOdd
        return shadowLayer
    }()

    lazy var outShadowSubLayer = CAShapeLayer().then {
        $0.shadowColor = CheezeAsset.Colors.primaryColor2.color.cgColor
        $0.shadowOffset = CGSize(width: 0, height: 0)
        $0.shadowOpacity = 5
        $0.shadowRadius = 20
        $0.fillRule = .evenOdd
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        configureUI()

        let shadowPath = UIBezierPath(rect: bounds.insetBy(dx: -innerShadowLayer.shadowRadius * 2.0,
                                                           dy: -innerShadowLayer.shadowRadius * 2.0))

        shadowPath.append(UIBezierPath(rect: bounds))

        self.innerShadowLayer.path = shadowPath.cgPath
        self.innerShadowSubLayer.path = shadowPath.cgPath

        mainButton.layer.addSublayer(self.innerShadowLayer)
        mainButton.layer.addSublayer(self.innerShadowSubLayer)

        self.layer.shadowColor = CheezeAsset.Colors.primaryColor2.color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
    }

    private func setLayout() {
        mainButton.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }

    // MARK: - Helpers
    private func configureUI() {
        self.layer.cornerRadius = 20
    }
}
