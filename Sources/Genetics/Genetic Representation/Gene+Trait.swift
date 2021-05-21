//
//  Gene+Trait.swift
//  
//
//  Created by Russell on 5/20/21.
//

import Foundation

/// A given Trait of a Gene.
/// Simply the value of one allele.
/// Used to standardize values among genetic objects.
public struct Trait: Equatable, Hashable {
    public var value: AnyHashable
    
    public init(_ value: AnyHashable) {
        self.value = value
    }
    
    public static func == (lhs: Trait, rhs: Trait) -> Bool {
        return (lhs.value == rhs.value)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

/// A gene is a stretch of DNA that determines a certain trait, it is typically given a name and a value.
/// A gene can have many variations, each of these variations is called an `allele`.
public struct Gene {

    /// The name of this Gene, e.g. "Hair Color"
    public var name: String
    
    /// The values of all possible variations of the gene, "Black, Brown, Red, etc."
    public var alleles: [Trait]
    
    /// The Standard Initializer for this Structure.
    /// - Parameters:
    ///         named: String, a the human-readable name for this trait. i.e. "Eye Color"
    ///         alleles: [Trait], all given possible variations of the trait, i.e. ["Brown", "Hazel", "Green"].
    public init(named: String, alleles: [Trait]) {
        self.name = named
        self.alleles = alleles
    }
    
    /// Creates a random `Trait` from this genes alleles, returns nil if alleles.count == 0.
    public func randomTrait() -> Trait? {
        if let randomtrait = alleles.randomElement() {
            return randomtrait
        } else {
            return nil
        }
    }
}

