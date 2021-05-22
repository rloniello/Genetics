    import XCTest
    @testable import Genetics
    
    final class GeneTraitTests: XCTestCase {
        
        // Tests Gene Creation.
        func testGeneticGeneInitalization() {
            let gene = Gene(named: "Hair Color", alleles: [Trait("Red"), Trait("Black"), Trait("Brown")])
            XCTAssertNotNil(gene)
            XCTAssertNotNil(gene.name)
            XCTAssertNotNil(gene.alleles)
            XCTAssertNotNil(gene.randomTrait())
        }
        
        // Genes should return nil when no traits are present for them.
        func testGeneRandomTraitFailure() {
            let gene = Gene(named: "Darwin Award", alleles: [])
            XCTAssertNil(gene.randomTrait())
        }
        
        // Traits of the same value ought to be fully-Equatable.
        func testTraitEquivalence() {
            let xtrait = Trait("X")
            let xtrait2 = Trait("X")
            
            XCTAssertTrue(xtrait == xtrait2)
            XCTAssertTrue(xtrait.hashValue == xtrait2.hashValue)
        }
        
        static var allTests = [
            ("testGeneticGeneInitalization", testGeneticGeneInitalization),
            ("testGeneRandomTraitFailure",testGeneRandomTraitFailure),
            ("testTraitEquivalence", testTraitEquivalence)
        ]
    }
