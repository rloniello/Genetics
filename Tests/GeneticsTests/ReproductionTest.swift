import XCTest
@testable import Genetics

final class ReproductionTests: XCTestCase {
    /// A very real test object...
    struct Cryptid: Genetic {
        var fitness: Double = 0.2
        
        var chromosome: [Trait] = [Trait]()
        
        static var genome: [Gene] = [
            Gene(named: "Boolean", alleles: [Trait(true), Trait(false)]),
            Gene(named: "Int", alleles: [Trait(0), Trait(1)]),
            Gene(named: "String", alleles: [Trait("True"), Trait("False")]),
        ]
        
        func reproduce(with other: Genetic) throws -> Cryptid {
            // Reproduction will be controlled manually throughout the following tests.
            return self
        }
    }

    // MARK: - Single Point Crossover
    // Ensure reproduction method creates children as expected.
    func testSPCChildren() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let children = try first.standardSinglePointCrossover(point: first.chromosome.count / 2, with: second)
            XCTAssertTrue("111000" == children.firstBorn.chromosomeToString())
            XCTAssertTrue("000111" == children.secondBorn.chromosomeToString())
        } catch {
            XCTFail()
        }

    }
    
    // Ensure standardSinglePointCrossover returns the correct error type and value.
    func testSPCErrorBeyondIndex() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let _ = try first.standardSinglePointCrossover(point: 100, with: second)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("standardSinglePointCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .unableToReproduce)
        }
    }
    
    // Ensure standardSinglePointCrossover returns an error when trait lists do not match
    // but the crossover point is valid for both.
    func testSPCErrorMismatchingTraits() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let _ = try first.standardSinglePointCrossover(point: 2, with: second)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("standardSinglePointCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .unableToReproduce)
        }
    }
    
    // MARK: - Single Point Random Crossover
    
    // Ensures singlePointRandomCrossover produces an error when standardSinglePointCrossover does.
    func testSPRCFailure() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let _ = try first.singlePointRandomCrossover(with: second)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("standardSinglePointCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .unableToReproduce)
        }
    }
    
    // Ensures singlePointRandomCrossover produces vaild childen.
    // A valid child is one of the same chromosome length as their parents.
    // This method uses SPC, there is no need to determine trait value accuracy.
    // It has already been done with another test.
    func testSPRCVaildChildren() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            // When dealing with random values,
            // we should ensure the success of the test is not random itself.
            for _ in 0..<12 {
                let children = try first.singlePointRandomCrossover(with: second)
                XCTAssertTrue(children.firstBorn.chromosome.count == children.secondBorn.chromosome.count)
                XCTAssertTrue(children.secondBorn.chromosome.count == first.chromosome.count)
                XCTAssertTrue(children.firstBorn.chromosome.count != 0)
            }
        } catch {
            XCTFail("Error: \(error) occured")
        }
    }
    
    // MARK: - Uniform Crossover
    
    func testUCNotEnoughTraitsFailure() {
        let first = Cryptid(chromosome: [])
        let second = Cryptid(chromosome: [])
        
        do {
            let _ = try first.uniformCrossover(with: second)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("uniformCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .insufficientTraits)
        }
    }
    
    // Ensure the possibility of 100% rate transfer.
    func testUCFullTransfer() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let children = try first.uniformCrossover(with:second, atRate: 1.0)
            XCTAssertTrue(children.chromosome == first.chromosome)
        } catch {
            XCTFail("Rate Transfer was not 100%: \(error)")
        }
    }
    
    // Ensure the possibility of 0% rate transfer.
    func testUCFullExclusion() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let child = try first.uniformCrossover(with:second, atRate: 0.0)
            XCTAssertTrue(child.chromosome == second.chromosome)
        } catch {
            XCTFail("Rate Transfer was not 0%: \(error)")
        }
    }
    
    // Ensures the base rate of 50% gene transfer occurs within a large population.
    func testUCNearBaseRate() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(-1),Trait(-1),Trait(-1),Trait(-1),Trait(-1),Trait(-1)])
        
        var population = [Cryptid]()
        var totalDifference: Int = 0
        
        // as the population increases, the difference should decrease.
        for _ in 0..<10000 {
            do {
                let child = try first.uniformCrossover(with:second)
                population.append(child)
            } catch {
                XCTFail("An Error occured while running this test: \(error)")
            }
        }
        
        // Sum the values to (hopefully) zero.
        for member in population {
            totalDifference += member.chromosome.compactMap({ ($0.value as! Int) }).reduce(0,+)
        }
        
        XCTAssert((totalDifference <= 10), "The total difference in traits exeeded the expected amount, run the test again or inspect for changes to random number generation in uniformCrossover(with:,atRate:)")
    }
    
    
    // Ensures results from set rates do not differ to expected values.
    func testUCStaticRates() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
        let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
        
        do {
            let child = try first.uniformCrossover(with:second, atRates: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
            XCTAssertTrue(child.chromosome == first.chromosome)
            let anotherChild = try first.uniformCrossover(with:second, atRates: [1.0, 1.0, 1.0, 0.0, 0.0, 0.0])
            XCTAssertTrue(anotherChild.chromosome == [Trait(1),Trait(1),Trait(1),Trait(0),Trait(0),Trait(0)])
        } catch {
            XCTFail()
        }
    }
    
    // MARK: - Revolving Random Crossover
    // Ensures failure if chromosomes mismatch.
    func testRRCMismatchFailure() {
        let first = Cryptid(chromosome: [Trait(1)])
        let second = Cryptid(chromosome: [])
        // ... Checking chromosome count mismatch
        do {
            let _ = try first.revolvingRandomCrossover(with: second)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("revolvingRandomCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .unableToReproduce)
        }
    }
    
    
    // Ensures failure when the Proportion of genes cannot be met.
    func testRRCProportionFailure() {
        let first = Cryptid(chromosome: [Trait(1)])
        let thrid = Cryptid(chromosome: [Trait(1)])
        
        do {
            let _ = try first.revolvingRandomCrossover(with: thrid)
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail("revolvingRandomCrossover did not return a GeneticError")
                return
            }
            XCTAssertTrue(error.error == .unableToReproduce)
        }
    }
    
    func testRRCFunctionallity() {
        let first = Cryptid(chromosome: [Trait(1),Trait(1),
                                         Trait(1),Trait(1),
                                         Trait(1),Trait(1),
                                         Trait(1),Trait(1),
                                         Trait(1),Trait(1)])
        
        let second = Cryptid(chromosome: [Trait(0),Trait(0),
                                          Trait(0),Trait(0),
                                          Trait(0),Trait(0),
                                          Trait(0),Trait(0),
                                          Trait(0),Trait(0)])
        
        do {
            let child = try first.revolvingRandomCrossover(with: second)
            // check to see if 70% of traits from self (i.e. caller / first) are crossed over.
            XCTAssertTrue((child.chromosome.filter({($0.value as? Int) == 1}).count == 7))
        } catch {
            XCTFail()
        }
    }
    
    
    static var allTests = [
        // - SPC
        ("testSPCChildren", testSPCChildren),
        ("testSPCErrorBeyondIndex", testSPCErrorBeyondIndex),
        ("testSPCErrorMismatchingTraits",testSPCErrorMismatchingTraits),
        // - SPRC
        ("testSPRCFailure", testSPRCFailure),
        ("testSPRCVaildChildren", testSPRCVaildChildren),
        // - UC
        ("testUCNotEnoughTraitsFailure",testUCNotEnoughTraitsFailure),
        ("testUCFullTransfer",testUCFullTransfer),
        ("testUCFullExclusion", testUCFullExclusion),
        ("testUCNearBaseRate", testUCNearBaseRate),
        ("testUCStaticRates", testUCStaticRates),
        // - RRC
        ("testRRCMismatchFailure", testRRCMismatchFailure),
        ("testRRCProportionFailure", testRRCProportionFailure),
        ("testRRCFunctionallity", testRRCFunctionallity)
        
        
    ]
}
