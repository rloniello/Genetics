import XCTest

import GeneticsTests

var tests = [XCTestCaseEntry]()
tests += GeneTraitTests.allTests()
XCTMain(tests)
