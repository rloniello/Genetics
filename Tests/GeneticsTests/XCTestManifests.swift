import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GeneTraitTests.allTests),
        testCase(GeneticProtocolTests.allTests),
        testCase(ReproductionTests.allTests),
        testCase(MutationTests.allTests)
    ]
}
#endif
