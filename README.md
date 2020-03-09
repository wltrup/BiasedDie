# BiasedDie
![](https://img.shields.io/badge/platforms-iOS%2010%20%7C%20tvOS%2010%20%7C%20watchOS%204%20%7C%20macOS%2010.14-red)
[![Xcode](https://img.shields.io/badge/Xcode-11-blueviolet.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/wltrup/BiasedDie)
![GitHub](https://img.shields.io/github/license/wltrup/BiasedDie)

## What

**BiasedDie** is a Swift Package Manager package for iOS/tvOS (10.0 and above), watchOS (4.0 and above), and macOS (10.14 and above), under Swift 5.0 and above,  defining a generator of pseudo-random numbers based on a discrete distribution of probabilities.

In less formal terms, imagine that you have a die with `N` faces and that each face has a potentially different probability of being landed on than other faces. In other words, the `k`-th face has a probablity `pk` of being landed on, for `1 ≤ k ≤ N`. Of course, the sum of all of these probabilities must equal 1. This is referred to as a *biased die*. Now imagine that you throw this biased die many times, recording each time the number of the face the die lands on. This package lets you generate a sequence of such numbers as if you had actually thrown such a die, and does so as efficiently as possible, using a method known as the *alias method*. An excellent exposition of this method can be found [here](http://www.keithschwarz.com/darts-dice-coins/).

The package lets you initialise the biased die in multiple ways, depending on the kind of data you have or want to produce.

Once you initialise a die, you can sample from its distribution by calling its `next()` function, which returns a random item from the original list of *keys* (the die "faces"), with the correct probability.

Note that an instance of `BiasedDie<T: Hashable>` is an *immutable value*. All you can do with one, once initialised, is to sample from it. 

```swift
public struct BiasedDie<T: Hashable> {
    
    public init?(keysAndCounts: [T: Int])
    public init?(keysAndCounts: [Dictionary<T, Int>.Element])
    public init?(keysAndCounts: Dictionary<T, Int>.SubSequence)

    public init?(keysAndProbabilities: [T: Double])
    public init?(keysAndProbabilities: [Dictionary<T, Double>.Element])
    public init?(keysAndProbabilities: Dictionary<T, Double>.SubSequence)

    public func next() -> T
    
}

public extension BiasedDie where T == Int {
    
    init?(counts: [Int])
    init?(probabilities: [Double])
    
}
```

## Installation

**BiasedDie** is provided only as a Swift Package Manager package, because I'm moving away from CocoaPods and Carthage, and can be easily installed directly from Xcode.

## Author

Wagner Truppel, trupwl@gmail.com

## License

**BiasedDie** is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
