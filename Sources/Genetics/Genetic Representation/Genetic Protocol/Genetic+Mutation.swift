//
//  Genetic+Mutation.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

// MARK: Built in Mutation
extension Genetic {
    
    
    /// A universal mutation method utilizing the set of known alleles per trait in the Genetic Object's chromosome.
    ///
    ///- Warning:
    /// This method can violate in-place and in-order chromosomes when `shouldShuffle` is enabled.
    ///
    /// - Parameters:
    ///   - atRate: The Rate at which mutation occurs, default value is 0.03, or 3%.
    ///   - shouldShuffle: A boolean value indicating if the traits of self. should be suffled.
    public mutating func mutate(atRate: Double = 0.03, shouldShuffle:Bool = false) {
        // Ensure the mutation rate is never more than 1.
        var mutationRate:Double = atRate
        if (atRate > 1.0) {mutationRate = 1.0}
        if (drand48() < mutationRate) {
            // Randomly select trait to mutate.
            let randomIndex:Int = Int.random(in: 0...self.chromosome.count - 1)
            // Find the traits other's alleles in the genome and replace it with a random one.
            if let trait = Self.genome[randomIndex].randomTrait() {
                self.chromosome[randomIndex] = trait
            }
            // if requested, Shuffle the traits.
            if (shouldShuffle) { self.chromosome.shuffle() }
        }
    }
    
    
    /// A mutation method that randomly mutates dissimilar traits of weaker fitness individuals to ones of higher fitness.
    ///
    /// Following [Lamarckism](https://en.wikipedia.org/wiki/Lamarckism),
    /// Members of a population will tend to use the features of themselves that improve fitness overall.
    /// Since each member has a copy of the genetic materal, any member can 'adopt' a trait that may improve their fitness.
    /// These traits are chosen at random, and swapped only when they are not the same.
    ///
    /// - Important:
    /// For best results, always calculate fitness of the population passed to this function prior to calling this method.
    ///
    /// - Parameters:
    ///   - population: A population to compare caller to.
    ///   - limit: A limit on the number of chromosomes that should be swapped.
    public mutating func lamarckMutation<G:Genetic>(withRespectTo population: [G], limit: Int = 1) {
        guard let moreFitMember = population.filter({$0.fitness > self.fitness}).randomElement() else {
            return
        }
        // attempt to find the first random instance of a trait that doesnt match.
        // set selfs' trait at that position to the more fit member's value.
        // exit after changing a single trait.
        let allIndexes = [Int].init(0..<self.chromosome.count).shuffled()
        var swapped: Int = 0
        for value in allIndexes {
            if (self.chromosome[value] != moreFitMember.chromosome[value]) {
                self.chromosome[value] = moreFitMember.chromosome[value]
                swapped += 1
                if (swapped >= limit) {
                    return
                }
            }
        }
    }
    
}
