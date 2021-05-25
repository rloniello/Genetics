import XCTest

import GeneticsTests

var tests = [XCTestCaseEntry]()
tests += GeneTraitTests.allTests()
tests += GeneticProtocolTests.allTests()
tests += ReproductionTests.allTests()
tests += MutationTests.allTests()
XCTMain(tests)
