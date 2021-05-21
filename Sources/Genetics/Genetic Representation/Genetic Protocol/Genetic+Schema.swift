//
//  Genetic+Schema.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

// MARK: Schema Detection
extension Genetic {
    
    /// Detects and returns common Schema in a Genetic Object Population.
    /// Schema are sets of simular traits among members of the population with fitness greater than 0.
    /// Calculate fitness before running this method.
    /// - Parameters:
    ///   - population: The Genetic Population to be tested
    ///   - minimumMatchingGenes: The minimum number of matching traits before a set of traits can be considered a schema, default is 3.
    /// - Returns: A collection of Schema (array of an array of traits) atleast `minimumMatchingGenes` long.
    public func findSchemaIn(_ population: [Genetic], minimumMatchingGenes: Int = 3) -> [[Trait]] {
        var schema = Set<[Trait]>()
        // return empty if:
        // minimumMatchingGenes is 0, or minimumMatchingGenes is greater than the chromosome length.
        // in either case, matches cannot be found.
        if (minimumMatchingGenes <= 0 || (population.first?.chromosome.count ?? 0 < minimumMatchingGenes)) {
            return Array(schema)
        }
        // Group the objects by fitness.
        var grouped = Dictionary(grouping: population, by: {$0.fitness})
        // Remove all schema values of zero fitness.
        grouped.removeValue(forKey: 0.0)
        // but...
        // not really interested in fitness other than to sort with.
        for (_, members) in grouped {
            let chromosomes = members.map({ $0.chromosome })
            var uniqueChromosomes = Set<[Trait]>()
            // find members with different chromosomes.
            // automatically weeding-out same chromosomes with a Set.
            for traitCollection in chromosomes {
                uniqueChromosomes.insert(traitCollection)
            }
            
            // The threshold at which the population with a fitness greater than 0
            // could be said to have this trait. (~50%)
            // At least half of the population shows this gene sequence.
            // (can typecast to 0)
            let threshold = Int(Double(uniqueChromosomes.count - 1) / 2.0)
            
            for set in uniqueChromosomes {
                var startIndex: Int = 0
                // At least one match will allways occur. (self comparison)
                var matches: Int = -1
                // iterate step-wise through the chromosome by length of minimumMatchingGenes.
                while ((startIndex + minimumMatchingGenes) < set.count) {
                    let subset = Array(set[startIndex..<minimumMatchingGenes + startIndex])
                    for traitCollection in uniqueChromosomes {
                        // if we find a match increment the match counter.
                        // see `Array.containsInOrder(_:)` in `../Utility/Array+Utility.swift`
                        if (traitCollection.containsInOrder(subset)) {
                            matches += 1
                        }
                    }
                    
                    // Once we are through all the unique chromosomes.
                    // if we have found enough matches add this chromosome trait collection to
                    // the output schema.
                    if (matches >= threshold) {
                        schema.insert(subset)
                    }
                    // Continue...
                    startIndex += 1
                }
            }
        }
        
        return Array(schema)
    }
}

