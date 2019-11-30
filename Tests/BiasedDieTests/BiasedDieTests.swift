import XCTest
@testable import BiasedDie

final class BiasedDieTests: XCTestCase {

    static var allTests = [
        ("test_noData", test_noData),
        ("test_invalidData", test_invalidData),
        ("test_init_counts", test_init_counts),
        ("test_init_probs", test_init_probs),
    ]

    func test_noData() {
        let die = BiasedDie(counts: [])
        XCTAssertTrue(die == nil)
    }

    func test_invalidData() {
        let ints = [-10, -20, 0, 30]
        let die = BiasedDie(counts: ints)
        XCTAssertTrue(die == nil)
    }

    func test_init_counts() {
        var counts = (1 ... 2).map { _ in Int.random(in: 300 ... 400) }
        counts += [1000 - counts.reduce(0, +)]
        let keys = (0 ..< counts.count).map { $0 }
        let die = BiasedDie(counts: counts)
        let trials = (1 ... 200_000).compactMap { _ in die?.next() }
        let counter = Counter(data: trials)
        let probs = counter.probs()
        let res = keys.compactMap { probs[$0] }
        let tot = counts.reduce(0, +)
        let exp = keys.compactMap { Double(counts[$0]) / Double(tot) }
        let diffs = zip(res, exp).map { r, e in abs(r-e) }
        let result = diffs.map { x in x < 0.01 }.reduce(true) { $0 && $1 }
        XCTAssertTrue(result)
    }

    func test_init_probs() {
        var counts = (1 ... 2).map { _ in Int.random(in: 300 ... 400) }
        counts += [1000 - counts.reduce(0, +)]
        let tot = counts.reduce(0, +)
        let probsA = counts.map { Double($0) / Double(tot) }
        let keys = (0 ..< counts.count).map { $0 }
        let die = BiasedDie(probabilities: probsA)
        let trials = (1 ... 200_000).compactMap { _ in die?.next() }
        let counter = Counter(data: trials)
        let probs = counter.probs()
        let res = keys.compactMap { probs[$0] }
        let exp = probsA
        let diffs = zip(res, exp).map { r, e in abs(r-e) }
        let result = diffs.map { x in x < 0.01 }.reduce(true) { $0 && $1 }
        XCTAssertTrue(result)
    }

}
