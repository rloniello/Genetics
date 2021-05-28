# Genetics

### Introduction & Objectives

Genetics is a Swift Package that provides complete support for Genetic Algorithms using The Swift Programing Language.
The purpose of this package is to allow Swift Developers, Computer Scientist and other Researchers to easlily implement Genetic Algorithms in their iOS, macOS and iPadOS apps. This genetics library is one of the few that supports in-order and in-place chromosome and mutation support.

In complex apps it is sometimes advantagous to generate high-quality solutions to bounded or unbounded optimization problems. The Genetics Package allows the developer to implement a metaheuristic approach rather than rely on brute force computation or other machine learning methods.
When used properly, even complex problems with permuations of approximatly 10^144 can be found in less than 20 iterations, see "NthLetterSearch" example provided below.

### Features
- [x] In-place and in-order Trait support.
- [x] Built-in Fitness Evaluation Methods.
- [x] Built-in Selection Methods.
- [x] Standard Mutation, Crossover and Reproduction Support.
- [x] Individual Chromosome and Organism Genome Support.
- [x] Error Handling for Genetic Algorithm actions.
- [x] Named Genes supporting multiple Traits.
- [x] Random Trait Initialization from a Genome.
- [x] Random Population Generation form a Genome.
- [x] Support for AnyHashable Trait value, including other structs and classes.

### Getting Started
For basic use, Implementation is quite straight-forward:
0) Add Genetic to your project. 
Add Genetics package to your project. [Find out how here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

Then import to your Source files. 
```Swift
import Genetics
```
1) Define a Data Model and Enviroment.
This is representation of your Genetic Object. 
You only need to define a Genome for your object, which is a list of Genes. 
```Swift
// The Model
struct Jabberwocky: Genetic {
    var fitness: Double = 0.0
    
    var chromosome: [Trait] = [Trait]()
    
    static var genome: [Gene] = [
        // A Trait can be any value type... 
        Gene(named: "Example Gene", alleles: [Trait(true), Trait(false), Trait("Snarl"), Trait(110)]),
        Gene(named: "Wing Span", alleles: [Trait(0.9), Trait(1.0), Trait(1.2), Trait(1.8)]),
        // ...
    ]
    
    func reproduce(with other: Genetic) throws -> Jabberwocky {
        let another = Jabberwocky(chromosome: other.chromosome)
        return try self.uniformCrossover(with:another)
    }
}
// The Enviroment
var naturalEnviroment: NaturalEnviroment? = nil
```

2) Define your Operators.
[Genetic Operators](https://en.wikipedia.org/wiki/Genetic_operator) are any function that takes a population as input and returns nothing. 
They are defined as follows:
```Swift
public typealias GeneticOperation = (_ population: inout [Genetic]) -> Void
```
Genetic Members of the population can be altered, removed, added, etc.
Usually many GA's have methods for calculating fitness, determining termination condition, selection & breeding as well as mutation.
You may also update the UI, perform background tasks or change runing parameters on the fly.

```Swift
// You can define your own.. 
let calculateFitnessMethod: GeneticOperation =  { population in
    for (index, member) in population.enumerated() {
        // Read-only:
        // member.chromosome
        // Mutable:
        // population[index].fitness = ... 
    }
}

let shouldEndOperation: GeneticOperation = { population in 
    population.sort(by: {$0.fitness > $1.fitness})
    if (population[0].fitness > 1.0) {
        naturalEnviroment?.stop()
    }
}

// ..And/Or you can use built in methods: 
let fitnessMethod = FitnessMethods.hammingDistance(to: "tenletters")
let selectionMethod = SelectionMethods.BasicTournamentSelection()
// etc. 
```
3) Set the Enviroment and Start!
A Natural Enviroment is a standarized GA that takes a Genetic Object type and a list of Genetic Operators to perform on them. 
```Swift
// Defined Above in Step 1.
// Note: Operations are performed in-order of appearance, then repeated over and over again until you call 
// naturalEnviroment.stop() or set naturalEnviroment.shouldContinue to false.

let operations = [calculateFitness, pauseOperation, selectionMethod, mutationMethod]
naturalEnviroment = NaturalEnvironment(for: Jabberwocky.self, operations: operations)
naturalEnviroment.start()
```

### What does "In-place and In-order" mean ?
The Genetics Package is structed such that:
Each Gene contains a list of traits as allele's.
Each Genetic Object contains: 
1) A Genome that is a list of Gene objects. 
2) A chromosome that is a list of Trait objects.
![in-place and in-order](/Images/Inorderandinplace.png)


### Note on Older Versions
Older versions for Swift 5 and below no longer exist.
Versions prior to 3.0 are no longer supported or available. This package bundle was created prior to the creation of Swift Packages and has undergone several changes since it's original inception and design in 2016.
