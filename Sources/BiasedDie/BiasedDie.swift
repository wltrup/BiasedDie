import Foundation

/// Uses the alias method to create a biased multi-sided die.
/// Based on http://www.keithschwarz.com/darts-dice-coins/
///
/// Instances of `BiasedDie<T: Hashable>` are *immutable values*. All you can do with one,
/// once initialised, is to sample from it.
///
public struct BiasedDie<T: Hashable>: Hashable {
    
    public let keys: [T]

    /// Initialises an instance from a list of unique keys and their counts.
    ///
    public init?(keysAndCounts: [T: Int]) {
        self.init(keysAndProbabilities: keysAndCounts.mapValues(Double.init))
    }

    /// Initialises an instance from a list of unique keys and their counts.
    ///
    public init?(keysAndCounts: [Dictionary<T, Int>.Element]) {
        var d: [T: Int] = [:]
        keysAndCounts.forEach { d[$0.key] = $0.value }
        self.init(keysAndCounts: d)
    }
    
    /// Initialises an instance from a list of unique keys and their counts.
    ///
    public init?(keysAndCounts: Dictionary<T, Int>.SubSequence) {
        var d: [T: Int] = [:]
        keysAndCounts.forEach { d[$0.key] = $0.value }
        self.init(keysAndCounts: d)
    }

    /// Initialises an instance from a list of unique keys and their probabilities.
    ///
    public init?(keysAndProbabilities: [T: Double]) {

        guard keysAndProbabilities.isEmpty == false else { return nil }

        let keys = keysAndProbabilities.keys
        let values = keys.compactMap { keysAndProbabilities[$0] }

        let allNonNegative = values.map { $0 >= 0.0 }.reduce(true) { $0 && $1 }
        guard allNonNegative else { return nil }

        let total = values.reduce(0.0, +)
        var probs = values.map { $0 / total }

        let n = keysAndProbabilities.count
        let avg = 1.0 / Double(n)

        var aliasTable = [Int](repeating: 0, count: n)
        var probsTable = [Double](repeating: 0, count: n)

        var small = Stack<Int>()
        var large = Stack<Int>()

        func push(_ k: Int) {
            if probs[k] >= avg {
                large.push(k)
            } else {
                small.push(k)
            }
        }

        (0 ..< n).forEach(push)

        while (small.isEmpty == false) && (large.isEmpty == false) {
            let less = small.pop()!
            let more = large.pop()!
            probsTable[less] = Double(n) * probs[less]
            aliasTable[less] = more
            probs[more] += (probs[less] - avg)
            push(more)
        }

        while small.isEmpty == false {
            probsTable[small.pop()!] = 1.0
        }

        while large.isEmpty == false {
            probsTable[large.pop()!] = 1.0
        }

        self.keys = Array(keys)
        self.aliasTable = aliasTable
        self.probsTable = probsTable

    }

    /// Initialises an instance from a list of unique keys and their probabilities.
    ///
    public init?(keysAndProbabilities: [Dictionary<T, Double>.Element]) {
        var d: [T: Double] = [:]
        keysAndProbabilities.forEach { d[$0.key] = $0.value }
        self.init(keysAndProbabilities: d)
    }

    /// Initialises an instance from a list of unique keys and their probabilities.
    ///
    public init?(keysAndProbabilities: Dictionary<T, Double>.SubSequence) {
        var d: [T: Double] = [:]
        keysAndProbabilities.forEach { d[$0.key] = $0.value }
        self.init(keysAndProbabilities: d)
    }

    /// Samples from the probability distribution being modeled by the biased die
    /// on which the function is called, returning a randomly selected item from
    /// the die's list of keys, with the correct probability.
    ///
    public func next() -> T {
        let col = Int.random(in: 0 ..< probsTable.count)
        let toss = Double.random(in: 0 ... 1) < probsTable[col]
        let index = (toss ? col : aliasTable[col])
        return keys[index]
    }
    
    private let aliasTable: [Int]
    private let probsTable: [Double]
    
}

public extension BiasedDie where T == Int {
    
    /// Initialises an instance from an array of counts.
    /// The (0-based) array indices become their keys.
    ///
    init?(counts: [Int]) {
        var countsD: [Int: Int] = [:]
        counts.enumerated().forEach { k, value in countsD[k] = value }
        self.init(keysAndCounts: countsD)
    }
    
    /// Initialises an instance from an array of propabilities.
    /// The (0-based) array indices become their keys.
    ///
    init?(probabilities: [Double]) {
        var probsD: [Int: Double] = [:]
        probabilities.enumerated().forEach { k, value in probsD[k] = value }
        self.init(keysAndProbabilities: probsD)
    }
    
}

// MARK: - Internal API

struct Stack<T> {
    
    private(set) var m: [T] = []
    
    var isEmpty: Bool {
        return m.isEmpty
    }
    
    mutating func push(_ value: T) {
        m += [value]
    }
    
    mutating func pop() -> T? {
        return isEmpty ? nil : m.removeLast()
    }
    
}
