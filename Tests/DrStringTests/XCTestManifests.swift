#if !canImport(ObjectiveC)
import XCTest

extension ProblemCheckingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ProblemCheckingTests = [
        ("testBadParameterFormat", testBadParameterFormat),
        ("testBadParametersKeywordFormat", testBadParametersKeywordFormat),
        ("testBadReturnsFormat", testBadReturnsFormat),
        ("testBadThrowsFormat", testBadThrowsFormat),
        ("testCompletelyDocumentedFunction", testCompletelyDocumentedFunction),
        ("testGroupedParameterStyle", testGroupedParameterStyle),
        ("testIgnoreReturns", testIgnoreReturns),
        ("testIgnoreThrows", testIgnoreThrows),
        ("testLowercaseKeywords", testLowercaseKeywords),
        ("testMisalignedParameterDescriptions", testMisalignedParameterDescriptions),
        ("testMissingSectionSeparator", testMissingSectionSeparator),
        ("testMissingStuff", testMissingStuff),
        ("testNoDocNoError", testNoDocNoError),
        ("testRedundantKeywords", testRedundantKeywords),
        ("testSeparateParameterStyle", testSeparateParameterStyle),
        ("testUppercaseKeywords", testUppercaseKeywords),
        ("testWhateverParameterStyle", testWhateverParameterStyle),
    ]
}

extension SuperfluousExclusionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SuperfluousExclusionTests = [
        ("testAllowSuperfluousExclusion", testAllowSuperfluousExclusion),
        ("testNormalExclusionIsNotSuperfluous", testNormalExclusionIsNotSuperfluous),
        ("testNoSuperfluousExclusion", testNoSuperfluousExclusion),
        ("testSuperfluousExclusionBecauseItsNotIncludedToBeginWith", testSuperfluousExclusionBecauseItsNotIncludedToBeginWith),
        ("testSuperfluousExclusionViaGlob", testSuperfluousExclusionViaGlob),
        ("testYesSuperfluousExclusion", testYesSuperfluousExclusion),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ProblemCheckingTests.__allTests__ProblemCheckingTests),
        testCase(SuperfluousExclusionTests.__allTests__SuperfluousExclusionTests),
    ]
}
#endif
