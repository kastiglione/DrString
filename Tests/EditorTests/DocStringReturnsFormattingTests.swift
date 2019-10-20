import XCTest
@testable import Editor
@testable import Decipher

final class DocStringReturnsFormattingTests: XCTestCase {
    func testFormattingBasicReturns() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for returns.")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for returns."
            ]
        )
    }

    func testFormattingLowercaseKeyword() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for returns.")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            firstLetterUpperCase: false,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - returns: description for returns."
            ]
        )
    }

    func testFormattingColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for returns.")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 45,
            verticalAlign: false,
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "        /// - Returns: description for",
                "        ///            returns."
            ]
        )
    }

    func testFormattingColumnLimitPreservesLeadingWhitespaces() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for returns."),
                    .init("   ", "line 2 description for returns."),
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 44,
            verticalAlign: false,
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "        /// - Returns: description for",
                "        ///            returns.",
                "        ///   line 2 description for",
                "        ///   returns.",
            ]
        )
    }
}
