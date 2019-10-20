import Decipher

enum KeywordToFormat {
    case `throws`
    case returns
}

extension DocString.Entry {
    func formatAsParameter(initialColumn: Int, columnLimit: Int, maxPeerNameLength: Int?, firstLetterUpperCase: Bool, grouped: Bool) -> [String] {
        let keyword = firstLetterUpperCase ? "Parameter" : "parameter"
        let fullKeyword = grouped ? "" : " \(keyword)"
        let preDash = grouped ? "   " : " "

        let firstLineHeader = "\(preDash)-\(fullKeyword) \(self.name.text):"
        let verticalAlignPaddingCount = maxPeerNameLength.map {
            $0 - self.name.text.count
        } ?? 0

        let standardPadding = String(Array(repeating: " ", count: firstLineHeader.count + verticalAlignPaddingCount + 1))

        let standardStart = initialColumn
            + 3 // `///`
            + standardPadding.count
        var result = self.description.flatMap { line -> [String] in
            if line.text.isEmpty {
                return ["///"]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let useStandardPadding = standardPadding.count > lead.count
            let contentStart = useStandardPadding ? standardStart : line.lead.count + 3 + initialColumn
            let maxContentWidth = columnLimit - (contentStart > columnLimit ? standardStart : contentStart)
            let padding = useStandardPadding ? standardPadding : lead
            return fold(line: line.text, byLimit: maxContentWidth)
                .map { "///\(padding)\($0)"}
        }

        if let firstLine = result.first {
            let content = firstLine.dropFirst(3 + firstLineHeader.count)
            result[0] = "///\(firstLineHeader)\(content)"
        }

        return result
    }

    func format(_ keywordToFormat: KeywordToFormat, initialColumn: Int, columnLimit: Int, firstLetterUpperCase: Bool) -> [String] {
        let keyword: String
        switch(keywordToFormat, firstLetterUpperCase) {
        case (.throws, true):
            keyword = "Throws"
        case (.throws, false):
            keyword = "throws"
        case (.returns, true):
            keyword = "Returns"
        case (.returns, false):
            keyword = "returns"
        }

        let firstLineHeader = " - \(keyword):"
        let standardPadding = String(Array(repeating: " ", count: firstLineHeader.count + 1))
        let standardStart = initialColumn
            + 3 // `///`
            + standardPadding.count
        var result = self.description.enumerated().flatMap { (index, line) -> [String] in
            if line.text.isEmpty {
                return ["///"]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let useStandardPadding = standardPadding.count > lead.count && index == 0
            let contentStart = useStandardPadding ? standardStart : line.lead.count + initialColumn + 3
            let maxContentWidth = columnLimit - (contentStart > columnLimit ? standardStart : contentStart)
            let padding = useStandardPadding ? standardPadding : lead

            return fold(line: line.text, byLimit: maxContentWidth)
                .map { "///\(padding)\($0)"}
        }

        if let firstLine = result.first {
            let content = firstLine.dropFirst(3 + firstLineHeader.count)
            result[0] = "///\(firstLineHeader)\(content)"
        }

        return result
    }
}

extension DocString {
    func reformat(
        initialColumn: Int,
        columnLimit: Int,
        verticalAlign: Bool,
        firstLetterUpperCase: Bool,
        parameterStyle: ParameterStyle,
        separations: [Section]
    ) -> [String]
    {
        let padding = String(Array(repeating: " ", count: initialColumn))

        let description = self.description.flatMap { line -> [String] in
            if line.text.isEmpty {
                return ["///"]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let contentStart = initialColumn + 3 + lead.count
            let maxContentWidth = columnLimit - contentStart
            return fold(line: line.text, byLimit: maxContentWidth)
                .map { "///\(lead)\($0)"}
        }

        let maxParameterNameLength: Int?
        if verticalAlign {
            maxParameterNameLength = self.parameters.reduce(0) {
                max($0, $1.name.text.count)
            }
        } else {
            maxParameterNameLength = nil
        }

        let isGrouped = self.parameters.count > 1 &&
            (parameterStyle == .grouped ||
                parameterStyle == .whatever && self.parameterHeader != nil)

        let paramHeader = isGrouped ? ["/// - \(firstLetterUpperCase ? "P" : "p")arameters:"] : []

        let parameters = self.parameters.flatMap { param in
            param.formatAsParameter(
                initialColumn: initialColumn,
                columnLimit: columnLimit,
                maxPeerNameLength: maxParameterNameLength,
                firstLetterUpperCase: firstLetterUpperCase,
                grouped: isGrouped)
        }

        let formattedThrows = [
            self.throws.map {
                $0.format(
                    .throws,
                    initialColumn: initialColumn,
                    columnLimit: columnLimit,
                    firstLetterUpperCase: firstLetterUpperCase)
            }
        ]
            .compactMap { $0 }
            .flatMap { $0 }

        let formattedReturns = [
            self.returns.map {
                $0.format(
                    .returns,
                    initialColumn: initialColumn,
                    columnLimit: columnLimit,
                    firstLetterUpperCase: firstLetterUpperCase)
            },
        ]
            .compactMap { $0 }
            .flatMap { $0 }

        let separator = "///"

        var descriptionSeparator = [String]()
        if separations.contains(.description),
            let lastLine = description.last,
            lastLine != separator,
            (
                !parameters.isEmpty
                || !formattedThrows.isEmpty
                || !formattedReturns.isEmpty
            )
        {
            descriptionSeparator = [separator]
        }

        var parameterSeparator = [String]()
        if separations.contains(.parameters),
            let lastLine = parameters.last,
            lastLine != separator,
            (
                !formattedThrows.isEmpty
                || !formattedReturns.isEmpty
            )
        {
            parameterSeparator = [separator]
        }

        var throwsSeparator = [String]()
        if separations.contains(.throws),
            let lastLine = formattedThrows.last,
            lastLine != separator,
            !formattedReturns.isEmpty
        {
            throwsSeparator = [separator]
        }

        return [
            description,
            descriptionSeparator,
            paramHeader,
            parameters,
            parameterSeparator,
            formattedThrows,
            throwsSeparator,
            formattedReturns
        ]
            .flatMap { $0 }
            .map { padding + $0 }
    }
}

// Fold a line of text with natural language breaks until it fits in a colmun
// limit.
func fold(line: String, byLimit limit: Int) -> [String] {
    assert(limit > 0, "attempt to reflow text to by a non-positive limit: \(limit)")

    var remainder = line[...]
    var result = [String]()
    while remainder.count > limit {
        let segmentEnd = remainder.index(remainder.startIndex, offsetBy: limit)
        var cursor = segmentEnd
        while cursor > remainder.startIndex && remainder[cursor] != " " {
            cursor = remainder.index(before: cursor)
        }

        // Didn't find a good point to break in this segment, we need to look
        // forward until one is found and form a line from start of the segment
        // til there.
        if cursor == remainder.startIndex {
            cursor = segmentEnd
            while cursor < remainder.endIndex && remainder[cursor] != " " {
                cursor = remainder.index(after: cursor)
            }
        }

        result.append(String(remainder[..<cursor]))

        if cursor < remainder.endIndex, remainder[cursor] == " " {
            cursor = remainder.index(after: cursor)
        }

        remainder = remainder[cursor...]
    }

    result.append(String(remainder))
    return result
}
