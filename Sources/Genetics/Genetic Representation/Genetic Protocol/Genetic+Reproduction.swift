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
    /// See, [A Comparative Study of Modified Crossover Operators](https://sci-hub.se/10.1109/ICIIP.2015.7414781)
    ///
    /// Example:
    ///
    /// chomosome A =  [1 1 1 1 1 1 1]
    ///
    /// chomosome B = [0 0 0 0 0 0 0 ]
    ///
    /// Child One = [1 1 1 1 0 0 0]
    ///
    /// Child Two = [0 0 0 0 1 1 1]
    ///
    ///- Note:
    ///
    /// - Parameters:
    ///   - position: The index of the crossover point.
    ///   - other: Another `Genetic` Object.
    /// - Throws: `GeneticError` of type `.unableToReproduce`
    /// - Returns: Two `Genetic` Objects of the callers type.
    public func standardSinglePointCrossover(at position: Int, with other: Self) throws -> (childOne: Self, childTwo: Self) {
        // Ensure we can reproduce at the selected point.
        if (position >= self.chromosome.count || position >= other.chromosome.count) {
            throw GeneticError(error: .unableToReproduce)
        }
        
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

    public func uniformCrossover(with other: Self, atRate: Double) -> Self {
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
    
    public func uniformCrossover(with other: Self, atRates: [Double]) -> Self {
        precondition(self.chromosome.count == other.chromosome.count, "Chromosome lenghts between self and other must be equal.")
        precondition(self.chromosome.count == atRates.count, "The number of probabilities (count of) must be equal to the chromsome length.")
        var childTraits = [Trait]()
        let uniformRate:Double = drand48()
        
        for (index, trait) in self.chromosome.enumerated() {
            if (uniformRate > atRates[index]) {
                childTraits.append(trait)
            } else {
                childTraits.append(other.chromosome[index])
            }
        }
        
        return Self.init(chromosome: childTraits)
    }
    
    
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
