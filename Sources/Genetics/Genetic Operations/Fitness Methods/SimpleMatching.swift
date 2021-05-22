//
//  SimpleMatching.swift
//  
//
//  Created by Russell on 5/21/21.
//

import Foundation

extension FitnessMethods {
    
    /// Simple Matching Chromosomes.
    /// Compares a target chromosome with a given input.
    ///
    /// Fitness is caclulated on the number of matching Traits over the number of total Traits.
    /// Ex. 4 matching of 10 = 0.40%
    /// - Parameter targetChromosome: `[Trait]`
    /// - Returns: A `GeneticOperation`
    public static func matching(targetChromosome: [Trait]) -> GeneticOperation {
        let operation: GeneticOperation = { population in
            for (index, member) in population.enumerated() {
                let matching = Double(zip(targetChromosome, member.chromosome).filter(==).count)
                population[index].fitness = (matching / Double(targetChromosome.count))
            }
        }
        return operation
    }
    
    /// Matches a value against the value of the trait.
    /// Fitness is caclulated on the number of matching Traits over the number of total Traits.
    /// Ex. 2 matching of 10 = 0.20%
    /// - Parameter value: AnyHashable value, Int, Bool, String, etc.
    /// - Returns: A `GeneticOperation`
    public static func matching( _ value: AnyHashable) -> GeneticOperation {
        let operation: GeneticOperation = { population in
            for (index, member) in population.enumerated() {
                let matching = Double(member.chromosome.filter({$0.value == value}).count)
                population[index].fitness = (matching / Double(member.chromosome.count))
            }
        }
        return operation
    }
    
    
}
