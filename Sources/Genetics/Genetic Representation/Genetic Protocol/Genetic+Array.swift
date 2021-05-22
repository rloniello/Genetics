//
//  Genetic+Array.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

extension Array where Element: Equatable {
    /// Checks an array for in-order elements of another array:
    /// Will return true for arrays of single values.
    /// Examples:
    /// [1, 2, 3, 4, 5, 6].containsInOrder([1,2,3]) = true
    /// [1, 2, 3, 4, 5, 6].containsInOrder([1,2,4]) = false
    /// [1, 2, 3, 4, 5, 6].containsInOrder([]) = false
    /// [1, 2, 3, 4, 5, 6].containsInOrder([4,6]) = false
    /// [1, 2, 3, 4, 5, 6].containsInOrder([4]) = true
    /// [1, 2, 3, 4, 5, 6].containsInOrder([4,5,6]) = true
    /// - Parameter array:
    /// - Returns: `True` if all the elements are anywhere in this array and are in-order of appearence.
    func containsInOrder(_ array: [Element]) -> Bool {
        if (array.count <= 0) { return false }
        // continue if the first item is found.
        guard let index = self.firstIndex(of: array.first!) else {
            return false
        }
        // we know the first item matches, start there.
        // and check the rest.
        for next in 1..<array.count {
            guard let nextItemIndex = self.firstIndex(of: array[next]), nextItemIndex == (next + index) else {
                return false
            }
        }

        return true
    }
}

extension Array where Element: Genetic {
    /// Initializes a Genetic population with the given number of members.
    /// This method uses the Genetic Objects Genome to initalize.
    /// Enusre you have set the genome of your object before using this method.
    /// - Parameter randomPopulationOf: The number of members in the population.
    public init(randomPopulationOf: Int) {
        self.init()
        for _ in 0..<randomPopulationOf {
            self.append(Element.init(with: Element.genome))
        }
    }
    
    
    /// A Generic Genetic initialization method that Initializes a Genetic population with the given number of members.
    /// This method uses the Genetic Object's chromosome to initialize.
    /// Traits are chosen at random from the trait collection.
    ///
    /// - Warning:
    /// This method does not perserve in-order and in-place traits.
    ///
    /// - Parameters:
    ///   - randomPopulationOf: The number of members in the population.
    ///   - numberOfTraits: How many traits to copy from the given trait list.
    ///   - inTraitCollection: A list of traits to select from.
    public init(randomPopulationOf: Int, numberOfTraits: Int, inTraitCollection: [Trait]) {
        self.init()
        for _ in 0..<randomPopulationOf {
            var traits = [Trait]()
            for _ in 0..<numberOfTraits {
                traits.append(inTraitCollection.randomElement()!)
            }
            self.append(Element.init(chromosome: traits))
        }
    }
}
