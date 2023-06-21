import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Environments.appName,
    organizationName: Environments.organizationName,
    product: .app,
    packages: [
        .SnapKit,
        .Then,
        .Kingfisher,
        .RxSwift,
        .RxFlow
    ],
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.RxSwift,
        .SPM.RxFlow
    ],
    resources: ["Resources/**"],
    scripts: [.SwiftLintString],
    infoPlist: .file(path: "Support/Info.plist")
)
