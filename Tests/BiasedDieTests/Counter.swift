import Foundation

struct Counter<T: Hashable & Comparable> {
    
    private(set) var counts: [T: Int] = [:]

    init(data: [T] = []) {
        var counts: [T: Int] = [:]
        data.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        self.counts = counts
    }
    
    func total() -> Int {
        counts.values.reduce(0, +)
    }
    
    func probs() -> [T: Double] {
        guard counts.isEmpty == false else { return [:] }
        let tot = Double(total())
        return counts.mapValues { Double($0) / tot }
    }
    
}
