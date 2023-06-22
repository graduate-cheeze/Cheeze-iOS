import ProjectDescription

extension TargetDependency {
    public struct SPM {}
}

public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.package(product: "SnapKit")
    static let Then = TargetDependency.package(product: "Then")
    static let Kingfisher = TargetDependency.package(product: "Kingfisher")
    static let RxSwift = TargetDependency.package(product: "RxSwift")
    static let RxFlow = TargetDependency.package(product: "RxFlow")
    static let Gradients = TargetDependency.package(product: "UIGradient")

}

public extension Package {
    static let SnapKit = Package.remote(
        url: "https://github.com/SnapKit/SnapKit.git",
        requirement: .upToNextMajor(from: "5.6.0")
    )
    static let Then = Package.remote(
        url: "https://github.com/devxoul/Then.git",
        requirement: .upToNextMajor(from: "3.0.0")
    )
    static let Kingfisher = Package.remote(
        url: "https://github.com/onevcat/Kingfisher",
        requirement: .upToNextMajor(from: "7.8.1")
    )
    static let RxSwift = Package.remote(
        url: "https://github.com/ReactiveX/RxSwift",
        requirement: .upToNextMajor(from: "6.5.0")
    )
    static let RxFlow = Package.remote(
        url: "https://github.com/RxSwiftCommunity/RxFlow",
        requirement: .upToNextMajor(from: "2.13.0")
    )
    static let Gradients = Package.remote(url: "https://github.com/Gradients/Gradients",
        requirement: .upToNextMajor(from: "0.3.1"))
}
