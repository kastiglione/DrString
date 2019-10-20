@testable import Decipher
@testable import Editor
import XCTest

final class DocStringParameterFormattingTests: XCTestCase {
    func testSeparateSingleParameter() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description"
            ]
        )
    }

    func testSeparateSingleParameterLowercase() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: false,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - parameter foo: foo's description"
            ]
        )
    }

    func testSeparateSingleParameterMultlineDescription() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's description",
            ]
        )
    }

    func testSeparateSingleParameterMultlineDescriptionWithInitialColumn() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 4,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "    /// - Parameter foo: foo's description",
                "    ///                  line 2 of foo's description",
            ]
        )
    }

    func testSeparateSingleParameterColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 40,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's",
                "///                  description",
            ]
        )
    }

    func testSeparateMultipleParametersNoVerticalAlignment() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's description",
                "/// - Parameter barbaz: barbaz's description",
                "///                     line 2 of barbaz's description",
            ]
        )
    }

    func testSeparateMultipleParametersVerticalAlignment() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: true,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo:    foo's description",
                "///                     line 2 of foo's description",
                "/// - Parameter barbaz: barbaz's description",
                "///                     line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParameters() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo: foo's description",
                "///          line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParametersVerticalAligned() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: true,
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo:    foo's description",
                "///             line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParametersOverColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 40,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo: foo's description",
                "///          line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's",
                "///             description",
            ]
        )
    }

    func testContinuationLineIsPaddedToProperLevel0() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init("             ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  continues",
            ]
        )
    }

    func testContinuationLineIsPaddedToProperLevel1() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init("                    ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                    continues",
            ]
        )
    }

    func testContinuationLineIsPaddedToProperLevel2() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "foo's description"),
                        .init("              ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  continues",
            ]
        )
    }
}
