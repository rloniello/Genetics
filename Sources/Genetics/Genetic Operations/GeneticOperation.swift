//
//  GeneticOperation.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

/// The standard method for manipulating a population of Genetic Objects.
/// Every genetic operation should take a mutable population and return nothing.
/// Changes to members of the population should happen in-place.
public typealias GeneticOperation = (_ population: inout [Genetic]) -> Void
