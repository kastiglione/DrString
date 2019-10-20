import XCTest
@testable import Editor
@testable import Decipher

final class DocStringThrowsFormattingTests: XCTestCase {
    func testFormattingBasicThrows() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for throws.")
                ]))

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
                "/// - Throws: description for throws."
            ]
        )
    }

    func testFormattingLowercaseKeyword() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for throws.")
                ]))

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
                "/// - throws: description for throws."
            ]
        )
    }

    func testFormattingColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for throws.")
                ]))

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 43,
            verticalAlign: false,
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "        /// - Throws: description for",
                "        ///           throws."
            ]
        )
    }

    func testFormattingColumnLimitPreservesLeadingWhitespaces() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "description for throws."),
                    .init("   ", "line 2 description for throws."),
                ]))

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 43,
            verticalAlign: false,
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "        /// - Throws: description for",
                "        ///           throws.",
                "        ///   line 2 description for",
                "        ///   throws.",
            ]
        )
    }
}
