import XCTest
@testable import Genetics

final class GeneticProtocolTests: XCTestCase {
    
    // Tests Object Initialization.
    func testInitalization() {
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
                // we don't care about reproduction in this test.
                return self
            }
        }
        
        // Standard Initialization should not initialize a chromosome.
        var lucy: Cryptid? = Cryptid()
        XCTAssertTrue(lucy?.chromosome.count == 0)
        // Fitness should be the initial value we set in the object.
        XCTAssertTrue(lucy?.fitness == 0.2)
        
        // When initalized from a genome the chromsome should contain the same number of traits
        // as the number of Genes in the chromosome.
        lucy = Cryptid(with: Cryptid.genome)
        XCTAssertTrue(lucy?.chromosome.count == 3)
        // Ensure fitness is mutable.
        lucy?.fitness = 1.0
        XCTAssertTrue(lucy?.fitness == 1.0)
    }
    
    func testChromosomeToString() {
        struct HelloWorld: Genetic {
            var fitness: Double = 0.2
            
            var chromosome: [Trait] = [Trait]()
            
            static var genome: [Gene] = [
                Gene(named: "first", alleles: [Trait("H"), Trait("h")]),
                Gene(named: "second", alleles: [Trait("E"), Trait("e")]),
                Gene(named: "thrid", alleles: [Trait("L"), Trait("l")]),
                Gene(named: "fourth", alleles: [Trait("L"), Trait("l")]),
                Gene(named: "fifth", alleles: [Trait("O"), Trait("o")]),
                Gene(named: "sixth", alleles: [Trait("W"), Trait("w")]),
                Gene(named: "seventh", alleles: [Trait("O"), Trait("o")]),
                Gene(named: "eighth", alleles: [Trait("R"), Trait("r")]),
                Gene(named: "ninth", alleles: [Trait("L"), Trait("l")]),
                Gene(named: "tenth", alleles: [Trait("D"), Trait("d")]),
            ]
            
            func reproduce(with other: Genetic) throws -> HelloWorld {
                // we don't care about reproduction in this test.
                return self
            }
        }
        
        let helloworld = HelloWorld(with: HelloWorld.genome)
        XCTAssertTrue(helloworld.chromosomeToString().lowercased() == "helloworld")
    }

    
    func testComplexTraitRepresentation() {
        
        
        struct Item: Codable, Equatable & Hashable {
            var name: String
            var value: Float
            var uuid: UUID = UUID()
        }
        
        struct Tove: Genetic {
            var fitness: Double = 0.0
            
            var chromosome: [Trait] = [Trait]()
            
            static var genome: [Gene] = [
                Gene(named: "First", alleles: [
                    Trait(Item(name: "1",value: -1.11)),
                    Trait(Item(name: "2",value: -2.22))
                ])
            ]
            
            func reproduce(with other: Genetic) throws -> Tove {
                return self
            }
        }
        
        let tove = Tove(with: Tove.genome)
        XCTAssert((tove.chromosome[0].value is Item), "AnyHashable value representation lost.")
    }
    
    
    static var allTests = [
        ("testInitalization", testInitalization),
        ("testChromosomeToString",testChromosomeToString),
        ("testComplexTraitRepresentation", testComplexTraitRepresentation)
    ]
}
