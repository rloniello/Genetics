//
//  NaturalEnvironment.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation


/// A Standard Genetic Object Enviroment in which Genetic Operations are executed.
public class NaturalEnvironment {
    
    /// The population of this Eviroment
    public var population: [Genetic]
    public var shouldContinue: Bool = true
    
    private var currentOperationIndex: UInt = 0
    private var operations: [GeneticOperation]
    
    public init<G:Genetic>(for object: G.Type, operations: [GeneticOperation]) {
        self.population = [G].init(randomPopulationOf: 1000)
        self.operations = operations
    }
    
    public init(with population: [Genetic], operations: [GeneticOperation]) {
        self.population = population
        self.operations = operations
    }
    
    public func start() {
        self.iterateOverOperations()
    }
    
    public func stop() {
        self.shouldContinue = false
    }
    
    public func `continue`() {
        self.shouldContinue = true
        self.iterateOverOperations()
    }
    
    private func iterateOverOperations() {
        while(self.shouldContinue) {
            if (currentOperationIndex > operations.count - 1) {
                currentOperationIndex = 0
            }
            operations[Int(currentOperationIndex)](&population)
            currentOperationIndex += 1
        }
    }
}

