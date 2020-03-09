import XCTest
@testable import BiasedDie

final class StackTests: XCTestCase {

    func test_isEmpty() {
        let s = Stack<Int>()
        XCTAssert(s.isEmpty == true)
    }

    func test_push_into_empty() {
        var s = Stack<Int>()
        s.push(10)
        XCTAssert(s.m == [10])
    }

    func test_push_into_non_empty() {
        var s = Stack<Int>()
        s.push(10)
        s.push(20)
        XCTAssert(s.m == [10, 20])
    }

    func test_pop_from_empty() {
        var s = Stack<Int>()
        XCTAssertTrue(s.pop() == nil)
        XCTAssert(s.m == [])
    }

    func test_pop_from_non_empty() {
        var s = Stack<Int>()
        s.push(10)
        s.push(20)
        XCTAssertTrue(s.pop() == 20)
        XCTAssert(s.m == [10])
        XCTAssertTrue(s.pop() == 10)
        XCTAssert(s.m == [])
    }

}
