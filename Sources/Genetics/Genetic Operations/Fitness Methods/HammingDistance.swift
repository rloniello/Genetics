//
//  HammingDistance.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

extension FitnessMethods {
    /// Calcuates fitness by how far off the chromosome is to a target String.
    /// see [Hamming Distance](https://en.wikipedia.org/wiki/Hamming_distance)
    ///
    /// Compares a `target` string with a given `Genetic` Object.
    /// Fitness is caclulated on the number of matching characters over the number of total characters.
    /// Ex. 3 matching of 10 = 0.30%
    /// - Parameter target: String
    /// - Returns: A `GeneticOperation`
    public static func hammingDistance(to target: String) -> GeneticOperation {
        let operation: GeneticOperation = { population in
            for (index, member) in population.enumerated() {
                let matching = Double(zip(target, member.chromosomeToString()).filter(==).count)
                population[index].fitness = Double( matching / Double(target.count) )
            }
        }
        return operation
    }
}
