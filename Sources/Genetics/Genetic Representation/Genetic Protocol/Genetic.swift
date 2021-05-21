//
//  Genetic.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

/// The base protocol for all Genetic Objects.
public protocol Genetic {
    /// The fitness of this creature.
    /// Typically represented between 0 and 1.
    var fitness: Double { get set }
    /// This creature's chromosome, its unique collection of in-order traits.
    var chromosome: [Trait] { get set }
    /// This creature's entire genome that is shared among all creatures of the same type.
    /// The complete set of genes or genetic material present.
    static var genome: [Gene] {get set}
    /// Genetic objects can initialize from a given chromosome for from a user-defined method.
    init()
    init(chromosome: [Trait])
    /// Attempt to reproduce with another Genetic Object, throw a `GeneticError` if needed.
    func reproduce(with other: Genetic) throws -> Self
}

// MARK: - Simple Chromosome to String
extension Genetic {
    /// Coverts the AnyHashable value of the chromosomes traits to a single String without spaces.
    /// - Returns: String
    public func chromosomeToString() -> String {
        var output = ""
        for trait in self.chromosome {
            output += trait.value.description
        }
        return output
    }
}


