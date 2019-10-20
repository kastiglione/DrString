/// A change to a file. All changes are assumed to be a range of lines.
public struct Edit {
    let path: String
    public let startingLine: Int
    public let endingLine: Int
    public let text: [String]
}
