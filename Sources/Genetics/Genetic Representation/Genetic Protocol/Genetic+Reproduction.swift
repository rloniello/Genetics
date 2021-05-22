//
//  Genetic+Reproduction.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

// MARK: Built-in Reproduction Methods.
extension Genetic {
    
    /// A universal crossover method that creates two children by spliting the parents chromosomes over each other.
    ///
    /// - Parameters:
    ///   - position: The index of the crossover point.
    ///   - other: Another `Genetic` Object.
    /// - Throws: `GeneticError` of type `.unableToReproduce`
    /// - Returns: Two `Genetic` Objects of the callers type.
    public func standardSinglePointCrossover(at position: Int, with other: Self) -> (childOne: Self, childTwo: Self) {
        // Ensure we can reproduce at the selected point.
        let precondtion:Bool = (position <= self.chromosome.count && position <= other.chromosome.count)
        precondition(precondtion, "Chromosomes length between self and other must be equal, traits cannot be copied when chromsome pairs are not the same length.")
        
        var childOneTraits = [Trait]()
        var childTwoTraits = [Trait]()
        
        childOneTraits.append(contentsOf: Array(self.chromosome[..<position]))
        childOneTraits.append(contentsOf: Array(other.chromosome[position...]))
        
        childTwoTraits.append(contentsOf: Array(self.chromosome[position...]))
        childTwoTraits.append(contentsOf: Array(other.chromosome[..<position]))
        
        return (Self.init(chromosome: childOneTraits), Self.init(chromosome: childTwoTraits))
    }
    
    
    /// A standard crossover method utilizing a random point in the chromosome.
    /// All non-matching traits between parents are moved over to the child.
    /// - Parameter other: Another object of type `Self`
    /// - Returns: A single child of type `Self`
    public func singlePointRandomCrossover(with other: Self) -> Self {
        let precondtion:Bool = (self.chromosome.count == other.chromosome.count) && (self.chromosome.count > 2)
        precondition(precondtion, "Chromosomes length must be greater than 2, and equal in length between self and other: \n self - \(self.chromosome), other: \(other.chromosome)")
        
        let randomIndex = Int.random(in: 1..<self.chromosome.count - 1)
        
        var childTraits = other.chromosome
        
        for index in 0..<randomIndex {
            if (childTraits[index] != self.chromosome[index]) {
                childTraits[index] = self.chromosome[index]
            }
        }
        return Self.init(chromosome: childTraits)
    }

    
    /// Performes uniform crossover at the given rate.
    /// Define a value between 1 and 0 for the rate.
    /// Genes from `other` are selected at the given rate, otherwise a trait is taken from the caller.
    /// - Parameters:
    ///   - other: Another Genetic Object of the same type
    ///   - atRate: The mutation rate for each gene, default value is 0.5 or 50%.
    /// - Returns: A child of the same type as the caller.
    public func uniformCrossover(with other: Self, atRate: Double = 0.5) -> Self {
        if (atRate >= 1.0) {
            return self
        }
        var childTraits = [Trait]()
        for (index, trait) in self.chromosome.enumerated() {
            if (drand48() < atRate) {
                childTraits.append(trait)
            } else {
                childTraits.append(other.chromosome[index])
            }
        }
        return Self.init(chromosome: childTraits)
    }
    
    
    /// Performes uniform crossover of each trait-position at a given rate.
    /// For each value, define a value between 1 and 0.
    /// The given rate is the probability the value will be selected from the caller.
    /// This is calculated by randomly generating a value between 0 and 1,
    /// if this value is less than the rate, then the trait is taken from the caller.
    ///
    /// 1) The number of traits must match between `self` and `other`.
    /// 2) The number of values in `atRates` must match the number of traits in the chromosome.
    ///
    /// - Parameters:
    ///   - other: Another Genetic Object of the same type
    ///   - atRates: An array of values between 1 and 0.
    /// - Returns: A child of the same type as the caller.
    public func uniformCrossover(with other: Self, atRates: [Double]) -> Self {
        precondition(self.chromosome.count == other.chromosome.count, "Chromosome lenghts between self and other must be equal.")
        precondition(self.chromosome.count == atRates.count, "The number of probabilities (count of) must be equal to the chromsome length.")
        var childTraits = [Trait]()
        for (index, trait) in self.chromosome.enumerated() {
            if (drand48() < atRates[index]) {
                childTraits.append(trait)
            } else {
                childTraits.append(other.chromosome[index])
            }
        }
        
        return Self.init(chromosome: childTraits)
    }
    
    /// A universal crossover method intended to be a dynamic solution to hill-climbing stagnation.
    ///
    /// Revolving Random Crossover (RRC) is an active crossover method that randomly selects a point in the chromosome,
    /// then copies a given proportion of Traits from the caller over to the child.
    /// This copying of traits does not end when the end of the chromsome is reached. Instead, copying begins again at the beginning.
    /// Thus "revolving" around the chromsome.
    /// Since we are copying a proportion of the traits rather than a range (as in single point crossover) we can vary the proportion
    /// of traits if desired, resulting in an increase in mixed traits while helping to preserve schema by grouping parts of the the chromosome.
    /// - Parameters:
    ///   - other: Another Genetic Object of the same type
    ///   - proportion: The proportion of traits that ought to be copied from the caller. Use a value between 0 and 1. default is 0.7, or 70%
    ///   - shouldDifferProportion: Wether or not the proportion of copied traits should vary (up to the given proportion)
    /// - Returns:A child of the same type as the caller.
    public func revolvingRandomCrossover(with other: Self, proportion: Double = 0.7, shouldDifferProportion: Bool = false) -> Self {
        precondition(self.chromosome.count == other.chromosome.count, "Chromosome lenghts between self and other must be equal.")
        let preconditon:Bool = ((proportion < 1.0) || (Int(proportion * Double(other.chromosome.count)) <= self.chromosome.count))
        precondition(preconditon, "The proportion of copied genes cannot be over 100% of the length of self or others chromosome.")
        // Continue...Initialize child traits from parent.
        var childTraits = other.chromosome
        // Randomly select the splice point.
        let splicePoint = Int.random(in: 0..<chromosome.count)
        // Find how many are going to be swapped.
        var swapCount:Int = 0
        if (!shouldDifferProportion) {
            // If there is NOT variable crossover just find a common crossover point.
            swapCount = Int(proportion * Double(other.chromosome.count))
        } else {
            // ... variable Crossover is active,
            // generate a random number between 0 and the proportion of genes selected.
            swapCount = Int.random(in: 0..<Int(proportion * Double(other.chromosome.count)))
        }
        // Iterate from 0 to swap count, swapping genes from parent to parent.
        // if the index goes beyond the index of the chromosomes array, start back at 0.
        var beyondIndex = 0
        for index in 0..<swapCount {
            if ((index + splicePoint) < (self.chromosome.count)) {
                childTraits[splicePoint + index] = self.chromosome[splicePoint + index]
            } else if (beyondIndex < self.chromosome.count) {
                childTraits[beyondIndex] = self.chromosome[beyondIndex]
                beyondIndex += 1
            }
        }
        return Self.init(chromosome: childTraits)
    }
}
