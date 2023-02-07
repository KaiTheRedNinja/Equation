//
//  MultiplicationGroup.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

public struct MultiplicationGroup {
    @UnitBuilder
    public var units: [EquationUnit]

    init(@UnitBuilder units: () -> [EquationUnit]) {
        self.units = units()
    }

    public func evaluate(values: [Double]) -> Double {
        assert(values.count == units.count)
        return Array(units.enumerated()).reduce(Double(1)) { partialResult, value in
            partialResult * value.element.valueForUnit(values[value.offset])
        }
    }

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

public enum SolveTarget: Equatable, Hashable {
    case top(Int)
    case bottom(Int)
}

@resultBuilder
public struct UnitBuilder {
    static func buildBlock(_ components: EquationUnit...) -> [EquationUnit] {
        Array(components)
    }
}
