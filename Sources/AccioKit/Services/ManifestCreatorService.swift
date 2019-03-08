import Foundation

final class ManifestCreatorService {
    static let shared = ManifestCreatorService(workingDirectory: FileManager.default.currentDirectoryPath)

    private let workingDirectory: String

    init(workingDirectory: String) {
        self.workingDirectory = workingDirectory
    }

    func createManifestFromDefaultTemplateIfNeeded(projectName: String, targetNames: [String]) throws {
        let packageManifestPath = URL(fileURLWithPath: workingDirectory).appendingPathComponent("Package.swift").path

        guard !FileManager.default.fileExists(atPath: packageManifestPath) else {
            print("Package.swift file already exists, skipping template based creation.", level: .warning)
            return
        }

        let targetsContents = self.targetsContents(targetNames: targetNames)
        let manifestTemplate = self.manifestTemplate(projectName: projectName, targetsContents: targetsContents)

        FileManager.default.createFile(atPath: packageManifestPath, contents: manifestTemplate.data(using: .utf8), attributes: nil)
        print("Created manifest file Package.swift from template.", level: .info)
    }

    private func manifestTemplate(projectName: String, targetsContents: String) -> String {
        return """
            // swift-tools-version:4.2
            import PackageDescription

            let package = Package(
                name: \"\(projectName)\",
                products: [],
                dependencies: [
                    // add your dependencies here, for example:
                    // .package(url: \"https://github.com/User/Project.git\", .upToNextMajor(from: \"1.0.0\")),
                ],
                targets: [
            \(targetsContents)    ]
            )

            """
    }

    private func targetsContents(targetNames: [String]) -> String {
        return targetNames.reduce("") { result, targetName in
            return result + """
                        .target(
                            name: \"\(targetName)\",
                            dependencies: [
                                // add your dependencies scheme names here, for example:
                                // \"Project\",
                            ]
                        ),

                """
        }
    }
}