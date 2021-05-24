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
    /// The chromsome of the caller is split at the point `between` the array's index points.
    /// The offset point is the position to the left of the index.
    /// An offset point of 0 at the begining of the array, an offset of 1 is between indexes 0 and 1.
    /// Thus only the traits beyond the first will be swapped. See the example below.
    ///
    /// ```
    /// let first = Cryptid(chromosome: [Trait(1),Trait(1),Trait(1),Trait(1),Trait(1),Trait(1)])
    /// let second = Cryptid(chromosome: [Trait(0),Trait(0),Trait(0),Trait(0),Trait(0),Trait(0)])
    /// let children = try! first.standardSinglePointCrossover(offset: first.chromosome.count / 2, with: second)
    /// print(children.firstBorn.chromosomeToString()) // 111000
    /// print(children.secondBorn.chromosomeToString()) // 000111
    /// ```
    /// - Parameters:
    ///   - point: The offset point between indexes where the chromosome is split.
    ///   - other: Another `Genetic` Object.
    /// - Throws: `GeneticError` of type `.unableToReproduce`
    /// - Returns: A tuple of two `Genetic` Objects of the callers type.
    public func standardSinglePointCrossover(point: Int, with other: Self) throws -> (firstBorn: Self, secondBorn: Self) {
        // Ensure we can reproduce at the selected point.
        let equalTraitCount: Bool = (self.chromosome.count == other.chromosome.count)
        let withinRange:     Bool = (point > 0 && point < self.chromosome.count)
        
        if (!equalTraitCount || !withinRange) {
            throw GeneticError("Trait count must be equal between self and other and must be within the range of operation (0 <-> chromosome.count - 1). value of point: \(point) may not be valid.", members: [self, other], error: .unableToReproduce)
        }
        
        var childOneTraits = [Trait]()
        var childTwoTraits = [Trait]()
        
        childOneTraits.append(contentsOf: Array(self.chromosome[..<point]))
        childOneTraits.append(contentsOf: Array(other.chromosome[point...]))
        
        childTwoTraits.append(contentsOf: Array(other.chromosome[..<point]))
        childTwoTraits.append(contentsOf: Array(self.chromosome[point...]))
        
        return (Self.init(chromosome: childOneTraits), Self.init(chromosome: childTwoTraits))
    }
    
    
    /// A standard crossover method utilizing a random point (offset) between traits in the chromosome.
    /// All non-matching traits between parents are moved over to the child.
    /// - Parameter other: Another object of type `Self`
    /// - Throws: `GeneticError` describing  the issue.
    /// - Returns: A tuple of two `Genetic` Objects of the callers type.
    public func singlePointRandomCrossover(with other: Self) throws -> (firstBorn: Self, secondBorn: Self) {
        let random = Int.random(in: 1..<self.chromosome.count - 1)
        return try self.standardSinglePointCrossover(point: random, with: other)
    }

    
    /// Performes uniform crossover at the given rate.
    /// Define a value between 1 and 0 for the rate.
    /// Genes from `other` are selected at the given rate, otherwise a trait is taken from the caller.
    /// - Parameters:
    ///   - other: Another Genetic Object of the same type
    ///   - atRate: The mutation rate for each gene, default value is 0.5 or 50%.
    /// - Throws: `GeneticError` describing  the issue.
    /// - Returns: A child of the same type as the caller.
    public func uniformCrossover(with other: Self, atRate: Double = 0.5) throws -> Self {
        let equalTraitCount: Bool = (self.chromosome.count == other.chromosome.count)
        let enoughTraits:    Bool = (self.chromosome.count >= 1)
        
        // Check preconditions...
        if (!equalTraitCount) {
            throw GeneticError("Chromosomes length between self and other must equal",
                               members: [self, other], error: .unableToReproduce)
        } else if (!enoughTraits) {
            throw GeneticError("Chromosomes length must be greater than or equal to 1, There are not enough traits to complete the task",
                               members: [self, other], error: .insufficientTraits)
        }
        
        // Continue...
        if (atRate >= 1.0) {
            return self
        }
        var childTraits = [Trait]()
        // For each trait, generate a random number between 0 and 1.
        for (index, trait) in self.chromosome.enumerated() {
            if (drand48() < atRate) {
                // if it is less than the rate, keep a trait from self.
                childTraits.append(trait)
            } else {
                // otherwise, take one from mate.
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
    /// - Throws: `GeneticError` describing  the issue.
    /// - Returns: A child of the same type as the caller.
    public func uniformCrossover(with other: Self, atRates: [Double]) throws -> Self {
        let equalTraits: Bool = (self.chromosome.count == other.chromosome.count)
        let equalRates:  Bool = (self.chromosome.count == atRates.count)
        
        if (!equalTraits) {
            throw GeneticError("Chromosome length between self and other must be equal.",
                               members: [self, other], error: .unableToReproduce)
        } else if (!equalRates) {
            throw GeneticError("The number of probabilities (count of) must be equal to the chromsome length.",
                               members: [self, other], error: .unableToReproduce)
        }
        // Continue...
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
    /// - Throws: `GeneticError` describing  the issue.
    /// - Returns:A child of the same type as the caller.
    public func revolvingRandomCrossover(with other: Self, proportion: Double = 0.7, shouldDifferProportion: Bool = false) throws -> Self {
        let equalTraits:  Bool = (self.chromosome.count == other.chromosome.count)
        let underMaximum: Bool = (Int(proportion * Double(other.chromosome.count)) <= self.chromosome.count)
        
        if (!equalTraits) {
            throw GeneticError("Chromosome lenghts between self and other must be equal.",
                               members: [self, other], error: .unableToReproduce)
        } else if (!underMaximum) {
            throw GeneticError("The proportion of copied genes cannot be over 100% of the length of self's or other's chromosome.",
                               members: [self, other], error: .unableToReproduce)
        }
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
