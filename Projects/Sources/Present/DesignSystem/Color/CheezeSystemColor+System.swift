import UIKit

public extension UIColor.CheezeColorSystem {
    enum System: CheezeColorable {
        case error
        case positive
        case black
        case white
    }
}

public extension UIColor.CheezeColorSystem.System {
    var color: UIColor {
        switch self {
        case .error: return CheezeAsset.Colors.error.color
        case .positive: return CheezeAsset.Colors.positive.color
        case .black: return CheezeAsset.Colors.black.color
        case .white: return CheezeAsset.Colors.white.color
        }
    }
}
