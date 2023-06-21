import ProjectDescription

public extension TargetScript {
    static let SwiftLintString = TargetScript.pre(script: """
# Type a script or drag a script file from your workspace to insert its path.
export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
""", name: "SwiftLintString")

    static let SwiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell"
    )
}
