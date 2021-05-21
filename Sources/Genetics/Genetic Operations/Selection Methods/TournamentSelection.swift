//
//  TournamentSelection.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

extension SelectionMethods {
    
    /// Tournament Selection is a selection method that "fights" three random members of the population.
    /// Members of the population are chosen based on a their fitness.
    /// Genetic Objects must calculate fitness before Tournament selection.
    /// - Returns:`GeneticOperation`
    public static func BasicTournamentSelection() -> GeneticOperation {
        let operation: GeneticOperation = { population in
            var offspring:[Genetic] = [Genetic]()
            let fighting: Int = 3
            if (population.count < fighting) { debugPrint(GeneticError(error: .insufficientPopulation)) }
            // while the offspring population is less than the given population.
            // Randomly Select pairs of fighting individuals.
            // Mate the two winners, and add the offspring to the next population.
            // Continue until we reach the same population.
            while (offspring.count < population.count) {
                var primary = [Genetic]()
                var secondary = [Genetic]()
                
                for count in 0..<(fighting*2) {
                    if (count % 2 == 0) {
                        primary.append(population.randomElement()!)
                    } else {
                        secondary.append(population.randomElement()!)
                    }
                }
                
                primary = primary.sorted(by: { $0.fitness > $1.fitness })
                secondary = secondary.sorted(by: { $0.fitness > $1.fitness })
        
                if let child = try? primary[0].reproduce(with: secondary[0]) {
                    offspring.append(child)
                } else {
                     debugPrint(GeneticError("Unable to Reproduce Primary Chromosome: \(primary[0].chromosome) and Secondary Chromosome: \(secondary[0].chromosome)", error: .unableToReproduce))
                }
            }
            population = offspring
        }
        return operation
    }
}
