//
//  MultiplicationGroup.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

public struct MultiplicationGroup {
    /// The units of the group
    @UnitBuilder
    public var units: [EquationUnit]

    public init(@UnitBuilder units: () -> [EquationUnit]) {
        self.units = units()
    }

    /// Given all the values, it evaluates the result of multiplying them all together,
    /// respecting things like if a unit is marked as squared.
    public func evaluate(values: [Double]) -> Double {
        assert(values.count == units.count)
        return Array(units.enumerated()).reduce(Double(1)) { partialResult, value in
            partialResult * value.element.valueForUnit(values[value.offset])
        }
    }

    /// Solves for a unit given the other values and the total value,
    /// respecting things like if a unit is marked as squared.
    public func solve(index: Int, given values: [Double], total: Double) -> Double {
        assert(values.count == units.count-1)
        // calculate the total of everything else
        let otherElements = Array(units.enumerated()).filter({ $0.offset != index }).map({ $1 })
        let otherTotal = Array(otherElements.enumerated()).reduce(Double(1)) { partialResult, value in
            partialResult * value.element.valueForUnit(values[value.offset])
        }
        let result = units[index].unitForValue(total/otherTotal)
        if result.isNaN {
            return 0
        }
        return result
    }
}

/// The role of a specific unit within an ``EquationGroup``
public enum SolveTarget: Equatable, Hashable {
    /// Item n of the numerator
    case top(Int)
    /// Item n of the denominator
    case bottom(Int)
}

@resultBuilder
public struct UnitBuilder {
    static func buildBlock(_ components: EquationUnit...) -> [EquationUnit] {
        Array(components)
    }
}
