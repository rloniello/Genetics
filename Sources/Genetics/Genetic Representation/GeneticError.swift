//
//  GeneticError.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

/// Possible errors that could occur with genetic objects.
public struct GeneticError: Error, CustomStringConvertible {
    public enum ErrorType: Equatable {
        /// The genetic diversity is threated.
        case threatedPopulation
        /// Population is going extinct.
        case insufficientPopulation
        /// There are not enough traits (in count or type) to complete the task.
        case insufficientTraits
        /// Incompatiable chromosomes, or phenotypes between Genetic Objects.
        case unableToReproduce
        /// A custom error message.
        case custom(_ error: String)
    }
    
    /// Message to the user about this error.
    public let message: String?
    /// The current Genetic Objects that produced the error, if any.
    public let members: [Genetic]?
    /// The produced error from the selection process.
    public let error: ErrorType
    
    public var description: String {
        return "Message: \(String(describing: message)), Member: \(String(describing: members)), Error: \(error)"
    }
    
    public init(_ message: String? = nil, members: [Genetic]? = nil, error: ErrorType) {
        self.message = message
        self.members = members
        self.error = error
    }
}
