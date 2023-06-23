import UIKit

public extension UIColor {
    enum CheezeColorSystem {
        case primary(Primary)
        case neutral(Neutral)
        case system(System)
    }

    static func cheezeColor(_ style: CheezeColorSystem) -> UIColor {
        switch style {
        case let .primary(colorable as CheezeColorable),
            let .neutral(colorable as CheezeColorable),
            let .system(colorable as CheezeColorable):
            return colorable.color
        }
    }
}
