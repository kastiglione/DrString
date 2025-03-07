import DrString
import FileCheck
import XCTest
import Critic

final class ProblemCheckingTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(
        fileName: String,
        ignoreThrows: Bool = false,
        ignoreReturns: Bool = false,
        verticalAlign: Bool = true,
        expectEmpty: Bool = false,
        firstLetter: Configuration.FirstKeywordLetterCasing = .uppercase,
        needsSeparation: [Section] = [],
        parameterStyle: ParameterStyle = .whatever
    ) -> Bool {
        let fixture = self.directory + "/Fixtures/" + "\(fileName).swift"
        return fileCheckOutput(against: .filePath(fixture), options: expectEmpty ? .allowEmptyInput : []) {
            _ = check(with: Configuration(
                includedPaths: [fixture],
                excludedPaths: [],
                ignoreDocstringForThrows: ignoreThrows,
                ignoreDocstringForReturns: ignoreReturns,
                verticalAlignParameterDescription: verticalAlign,
                superfluousExclusion: false,
                firstKeywordLetter: firstLetter,
                outputFormat: .plain,
                separatedSections: needsSeparation,
                parameterStyle: parameterStyle)
            )
        }
    }

    func testCompletelyDocumentedFunction() throws {
        XCTAssert(runTest(fileName: "complete", expectEmpty: true, firstLetter: .lowercase))
    }

    func testNoDocNoError() throws {
        XCTAssert(runTest(fileName: "nodoc", expectEmpty: true))
    }

    func testMissingStuff() throws {
        XCTAssert(runTest(fileName: "missingStuff", firstLetter: .lowercase))
    }

    func testIgnoreThrows() throws {
        XCTAssert(runTest(fileName: "ignoreThrows", ignoreThrows: true, firstLetter: .lowercase))
    }

    func testIgnoreReturns() throws {
        XCTAssert(runTest(fileName: "ignoreReturns", ignoreReturns: true, firstLetter: .lowercase))
    }

    func testBadParameterFormat() throws {
        XCTAssert(runTest(fileName: "badParamFormat", ignoreThrows: true))
    }

    func testBadThrowsFormat() throws {
        XCTAssert(runTest(fileName: "badThrowsFormat"))
    }

    func testBadReturnsFormat() throws {
        XCTAssert(runTest(fileName: "badReturnsFormat"))
    }

    func testMisalignedParameterDescriptions() throws {
        XCTAssert(runTest(fileName: "misalignedParameterDescription"))
    }

    func testLowercaseKeywords() throws {
        XCTAssert(runTest(fileName: "lowercaseKeywords", firstLetter: .lowercase))
    }

    func testUppercaseKeywords() throws {
        XCTAssert(runTest(fileName: "uppercaseKeywords", firstLetter: .uppercase))
    }

    func testMissingSectionSeparator() throws {
        XCTAssert(runTest(fileName: "missingSectionSeparator", expectEmpty: false,
                          needsSeparation: Section.allCases))
    }

    func testRedundantKeywords() throws {
        XCTAssert(runTest(fileName: "redundantKeywords", expectEmpty: false))
    }

    func testBadParametersKeywordFormat() throws {
        XCTAssert(runTest(fileName: "badParametersKeyword", expectEmpty: false, firstLetter: .uppercase))
    }

    func testSeparateParameterStyle() throws {
        XCTAssert(runTest(fileName: "separateParameterStyle", expectEmpty: false, parameterStyle: .separate))
    }

    func testGroupedParameterStyle() throws {
        XCTAssert(runTest(fileName: "groupedParameterStyle", expectEmpty: false, parameterStyle: .grouped))
    }

    func testWhateverParameterStyle() throws {
        XCTAssert(runTest(fileName: "whateverParameterStyle", expectEmpty: true, parameterStyle: .whatever))
    }
}
