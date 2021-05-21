//
//  GeneticError.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

/// Possible errors that could occur with genetic objects.
public struct GeneticError: Error, CustomStringConvertible {
    public enum ErrorType {
        /// The genetic diversity is threated.
        case threatedPopulation
        /// Population is going extinct.
        case insufficientPopulation
        /// Breeding apples and oranges, incompatiable chromosomes.
        case unableToReproduce
        /// A custom error message.
        case custom(_ error: String)
    }
    
    /// Message to the user about this error.
    let message: String?
    /// The current Genetic Object that produced the error.
    let member: Genetic?
    /// The produced error from the selection process.
    let error: ErrorType
    
    public var description: String {
        return "Message: \(String(describing: message)), Member: \(String(describing: member)), Error: \(error)"
    }
    
    public init(_ message: String? = nil, member: Genetic? = nil, error: ErrorType) {
        self.message = message
        self.member = member
        self.error = error
    }
    
    public init(_ message: String? = nil, error: ErrorType) {
        self.message = message
        self.member = nil
        self.error = error
    }
}
