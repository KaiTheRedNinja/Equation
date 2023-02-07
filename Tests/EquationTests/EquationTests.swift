import XCTest
@testable import Equation

final class EquationTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let topGrp = MultiplicationGroup {
            EquationUnit.v.squared()
        }
        let btmGrp = MultiplicationGroup {
            EquationUnit.p
            EquationUnit.r
        }

        let testEq = EquationGroup {
            topGrp
            btmGrp
        }

        // test EquationUnit.squared and MultiplicationGroup.solve
        XCTAssertEqual(topGrp.solve(index: 0, given: [], total: 25), 5)

        // test MultiplicationGroup.solve
        XCTAssertEqual(btmGrp.solve(index: 0, given: [10], total: 30), 3)
        XCTAssertEqual(btmGrp.solve(index: 1, given: [5], total: 70), 14)

        // test EquationGroup.solve
        XCTAssertEqual(testEq.solve(target: .top(0), topValues: [], bottomValues: [12, 3]), 6)
        XCTAssertEqual(testEq.solve(target: .bottom(0), topValues: [9], bottomValues: [3]), 27) // 81/3
        XCTAssertEqual(testEq.solve(target: .bottom(1), topValues: [12], bottomValues: [4]), 36)// 144/4

        // test other solve functions
        XCTAssertEqual(testEq.solve(target: .v.squared(), values: [
            .p: 12,
            .r: 3
        ]), 6)
        XCTAssertEqual(testEq.solve(target: .bottom(0), values: [
            .v.squared(): 9,
            .r: 3
        ]), 27)
        XCTAssertEqual(testEq.solve(target: .top(0), values: [:]), 0)
        let value = testEq.solve(target: .bottom(0), values: [:])
        XCTAssertEqual(value, 0)
    }

    func testEmptyLargeExample() throws {
        let testEq = EquationGroup {
            MultiplicationGroup {
                EquationUnit.rho
                EquationUnit.l
            }
            MultiplicationGroup {
                EquationUnit.r
                EquationUnit.a
            }
        }

        XCTAssertEqual(testEq.solve(target: .top(0), values: [:]), 0)
        XCTAssertEqual(testEq.solve(target: .top(1), values: [:]), 0)
        XCTAssertEqual(testEq.solve(target: .bottom(0), values: [:]), 0)
        XCTAssertEqual(testEq.solve(target: .bottom(1), values: [:]), 0)
    }

    func testDescriptions() throws {
        let testEq = EquationGroup {
            MultiplicationGroup {
                EquationUnit.v
            }
            MultiplicationGroup {
                EquationUnit.i
                EquationUnit.r
            }
        }

        XCTAssertEqual(testEq.description, "V = IR")
    }
}
