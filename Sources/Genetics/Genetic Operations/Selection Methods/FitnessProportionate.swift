//
//  File.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

extension SelectionMethods {
    /// This is an auxillary method used with other Selection Methods.
    /// Selects a member of the population based on their proportion of fitness to the total fitness.
    /// Genetic Objects must calculate fitness before proportionate selection.
    /// Members with higher fitness are chosen more often (proportionatly) than those those with lower fitness.
    /// - Parameter creatures: `[Genetic]`
    /// - Returns: `Genetic`
    public static func fitnessProportionateSelection(of creatures: [Genetic]) -> Genetic {
        precondition(!creatures.isEmpty, "Fitness cannot be determined with an empty population, please provide a non-empty array of creatures to \(#function)")
        // F is the total fitness of the population and f(i) is the fitness of a given individual.
        // p is the probability of selection.
        // p = f(i) / F
        // if we select a random fitness (R) value between 0 and F.
        // we can sum successive f(i) values to R.
        // The larger the value of f(i) that is next, the more likily it will be selected.
        let total = creatures.compactMap({ $0.fitness }).reduce(0, +)
        // Get a random target value between zero and the total fitness.
        precondition(total > 0.000, "Precondition Failure in: \(#function), -> Total Fitness of the population cannot be less than or equal to 0. Calculate fitness first or inspect fitness function.")
        let target = Double.random(in: 0..<total)
        var sum: Double = 0.0
        // The index of the creature that will be selected.
        var targetCreatureIndex: Int = 0
        // For each creature, add the sum of it's fitness until it is equal or greater value.
        for (index, member) in creatures.enumerated() {
            if (sum >= target) {
                break
            }
            sum += member.fitness
            targetCreatureIndex = index
        }
        
        return creatures[targetCreatureIndex]
    }
}
