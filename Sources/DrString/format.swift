import Crawler
import Dispatch
import Editor
import Pathos

public func format(with config: Configuration) {
    let included = Set((try? config.includedPaths.flatMap(glob)) ?? [])
    let excluded = Set((try? config.excludedPaths.flatMap(glob)) ?? [])

    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    for path in included.subtracting(excluded) {
        group.enter()
        queue.async {
            do {
                var edits = [Edit]()
                let (documentables, source) = try extractDocs(fromSourcePath: path)
                for documentable in documentables.compactMap({ $0 }) {
                    edits += documentable.format(
                        columnLimit: 110,
                        verticalAlign: config.verticalAlignParameterDescription,
                        firstLetterUpperCase: config.firstKeywordLetter == .uppercase,
                        parameterStyle: config.parameterStyle,
                        separations: config.separatedSections)
                }

                if !edits.isEmpty {
                    var editedLines = [String]()
                    let originalLines = source.split(separator: "\n", omittingEmptySubsequences: false)
                        .map(String.init)
                    var lastPosition = 0
                    for edit in edits {
                        editedLines += originalLines[lastPosition ..< edit.startingLine]
                        lastPosition = edit.endingLine
                        editedLines += edit.text
                    }

                    editedLines += originalLines[lastPosition...]

                    let finalText = editedLines.joined(separator: "\n")
                    try write(finalText, atPath: path)
                }
            } catch let error {
                fatalError(String(describing: error) + path)
            }

            group.leave()
        }
    }

    group.wait()
}
