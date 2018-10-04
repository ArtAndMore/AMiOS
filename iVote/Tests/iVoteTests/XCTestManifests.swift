import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(iVoteTests.allTests),
    ]
}
#endif