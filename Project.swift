import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Environments.appName,
    organizationName: Environments.organizationName,
    product: .app,
    packages: [
        .SnapKit,
        .Then,
        .Kingfisher
    ],
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
