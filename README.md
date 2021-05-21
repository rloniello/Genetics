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
1) Add Genetic to your project. 
Add Genetics package to your project. [Find out how here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

Then import to your Source files. 
```Swift
import Genetics
```
2) Create a Data Model that conforms to Genetic.
This is representation of your Genetic Object. 
You only need to define a Genome for your object, which is a list of Genes. 



3) Supply a Data Model, Fitness Method, and Selection Method to a Natural Enviroment.

### What does "In-place and In-order" mean ?
The Genetics Package is structed such that:
Each Gene contains a list of traits as allele's.
Each Genetic Object contains: 
1) A Genome that is a list of Gene objects. 
2) A chromosome that is a list of Trait objects.




### Note on Older Versions
Older versions for Swift 5 and below no longer exist.
Versions prior to 3.0 are no longer supported or available. This package bundle was created prior to the creation of Swift Packages and has undergone several changes since it's original inception and design in 2016.
