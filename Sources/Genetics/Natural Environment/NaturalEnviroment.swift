//
//  NaturalEnvironment.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation


/// A Standard Genetic Object Environment in which Genetic Operations are executed.
public class NaturalEnvironment {
    
    /// The population of this Eviroment
    public var population: [Genetic]
    /// whether or not the GA should continue genetic operations.
    public var shouldContinue: Bool = true
    /// The number of iterations this genetic operation has completed.
    public var currentIteration: Int = 0
    // The Index of the current operation.
    private var currentOperationIndex: UInt = 0
    // The operations that where initialized with this class.
    private var operations: [GeneticOperation]
    
    
    /// Initializes this class with a given Genetic Object type, and the genetic operators to perform.
    /// The first operation is performed first, after the last operation is performed we start back at the beginning.
    /// - Parameters:
    ///   - object: Any Object conforming to `Genetic`
    ///   - operations: A in-order list of genetic operators.
    public init<G:Genetic>(for object: G.Type, operations: [GeneticOperation]) {
        self.population = [G].init(randomPopulationOf: 1000)
        self.operations = operations
    }
    
    
    /// Manual Initalization of the population along with genetic operators.
    /// - Parameters:
    ///   - population: an Array of objects conforming to `Genetic`.
    ///   - operations:A in-order list of genetic operators.
    public init(with population: [Genetic], operations: [GeneticOperation]) {
        self.population = population
        self.operations = operations
    }
    
    /// Begin the Genetic Algorithm with the given operators.
    public func start() {
        self.iterateOverOperations()
    }
    
    /// Stops execution at the end of the current operation.
    public func stop() {
        self.shouldContinue = false
    }
    
    /// Continues the Genetic Algorithm with the given operators.
    public func `continue`() {
        self.shouldContinue = true
        self.iterateOverOperations()
    }
    
    /// Returns the number of Iterations (Generations) of the GA.
    /// - Returns: Int
    public func getCurrentIteration() -> Int {
        return self.currentIteration
    }
    
    // Simple iteration of operands.
    private func iterateOverOperations() {
        while(self.shouldContinue) {
            if (currentOperationIndex > operations.count - 1) {
                currentOperationIndex = 0
                currentIteration += 1
            }
            operations[Int(currentOperationIndex)](&population)
            currentOperationIndex += 1
        }
    }
}

