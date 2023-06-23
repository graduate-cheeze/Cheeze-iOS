import UIKit

public extension UIColor.CheezeColorSystem {
    enum Neutral: CheezeColorable {
        case neutral10
        case neutral20
        case neutral30
        case neutral40
        case neutral50
    }
}

public extension UIColor.CheezeColorSystem.Neutral {
    var color: UIColor {
        switch self {
        case .neutral10: return CheezeAsset.Colors.neutral10.color
        case .neutral20: return CheezeAsset.Colors.neutral20.color
        case .neutral30: return CheezeAsset.Colors.neutral30.color
        case .neutral40: return CheezeAsset.Colors.neutral40.color
        case .neutral50: return CheezeAsset.Colors.neutral50.color
        }
    }
}
