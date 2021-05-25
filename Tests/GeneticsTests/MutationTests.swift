import XCTest
@testable import Genetics

final class MutationTests: XCTestCase {
    
    /// A very real test object...
    struct Cryptid: Genetic {
        var fitness: Double = 0.0
        
        var chromosome: [Trait] = [Trait]()
        
        static var genome: [Gene] = [
            Gene(named: "A", alleles: [Trait(0), Trait(1)]),
            Gene(named: "B", alleles: [Trait(0), Trait(1)]),
            Gene(named: "C", alleles: [Trait(0), Trait(1)]),
            Gene(named: "C", alleles: [Trait(0), Trait(1)])
        ]
        
        func reproduce(with other: Genetic) throws -> Cryptid {
            // Reproduction will be controlled manually throughout the following tests.
            return self
        }
    }
    
    // MARK: - Simple Standard Mutation
    // Ensures a trait is mutated to the proper allele
    // after intialization with a chromosome.
    func testStandardMutation() {
        var first = Cryptid(chromosome: [Trait(0), Trait(0), Trait(0), Trait(0)])
        first.mutate(atRate: 1.0)
        XCTAssertTrue(first.chromosome.filter({($0.value as? Int) == 1}).count == 1)
    }
    
    // MARK: - Lamarck Mutation
    // Ensures the method returns an error for small populations.
    func testlamarckMutationFailure() {
        var first = Cryptid(chromosome: [Trait(0), Trait(0), Trait(0), Trait(0)])
        do {
            try first.lamarckMutation(withRespectTo: [Cryptid]())
        } catch {
            guard let error = error as? GeneticError else {
                XCTFail()
                return
            }
            XCTAssertTrue(error.error == .insufficientPopulation)
        }
    }
    
    func testNegativeFitnessInLM() {
        var first = Cryptid(chromosome: [Trait(0), Trait(0), Trait(1), Trait(0)])
        first.fitness = -1.2
        var second = Cryptid(chromosome: [Trait(1), Trait(1), Trait(0), Trait(0)])
        second.fitness = -2.3
        var thrid = Cryptid(chromosome: [Trait(0), Trait(0), Trait(0), Trait(0)])
        thrid.fitness = -3.2
        do {
            try thrid.lamarckMutation(withRespectTo: [first,second])
        } catch {
            XCTFail()
        }
        XCTAssertTrue(thrid.chromosome.filter({($0.value as? Int) == 1}).count == 1)
    }
    
    static var allTests = [
        // - Simple Standard Mutation
        ("testStandardMutation", testStandardMutation),
        // - Lamark Mutation
        ("testlamarckMutationFailure", testlamarckMutationFailure),
        ("testNegativeFitnessInLM", testNegativeFitnessInLM)
    ]
}
