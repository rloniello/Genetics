//
//  Genetic+Initialization.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

// MARK: Self initalization
extension Genetic {
    /// Initializes a Genetic Object from a list of traits.
    /// - Parameter chromosome: `[Trait]`
    init(chromosome: [Trait]) {
        self.init()
        self.chromosome = chromosome
    }
    
    /// A special initalizer that allows genetic objects to initalize form their genome.
    /// Keeping the number of traits equal to other members of the species.
    /// Conform to `Genotypic` for static initalization or provide a genome.
    /// Example: `MyGeneticObject(with: MyGeneticObject.genome)`
    public init(with randomGenome: [Gene]) {
        self.init(chromosome: [Trait]())
        for allele in randomGenome {
            if let randomTrait = allele.randomTrait() {
                self.chromosome.append(randomTrait)
            }
        }
    }
}
