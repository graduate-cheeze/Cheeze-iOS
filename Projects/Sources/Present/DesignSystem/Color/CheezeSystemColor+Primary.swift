import UIKit

public extension UIColor.CheezeColorSystem {
    enum Primary: CheezeColorable {
        case primary1
        case primary2
        case primary3
    }
}

public extension UIColor.CheezeColorSystem.Primary {
    var color: UIColor {
        switch self {
        case .primary1: return CheezeAsset.Colors.primaryColor1.color
        case .primary2: return CheezeAsset.Colors.primaryColor2.color
        case .primary3: return CheezeAsset.Colors.primaryColor3.color
        }
    }
}
