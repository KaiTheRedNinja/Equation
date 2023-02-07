//
//  MultiplicationGroup.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

struct MultiplicationGroup {
    @UnitBuilder
    var units: [EquationUnit]

    init(@UnitBuilder units: () -> [EquationUnit]) {
        self.units = units()
    }

    func evaluate(values: [Double]) -> Double {
        assert(values.count == units.count)
        return Array(units.enumerated()).reduce(Double(1)) { partialResult, value in
            partialResult * value.element.valueForUnit(values[value.offset])
        }
    }

    func solve(index: Int, given values: [Double], total: Double) -> Double {
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

struct EquationGroup {
    var topGroup: MultiplicationGroup
    var botGroup: MultiplicationGroup
    var flatUnits: [(EquationUnit, SolveTarget)] {
//        topGroup.units + botGroup.units
        topGroup.units.enumerated().map({ ($1, .top($0)) }) +
        botGroup.units.enumerated().map({ ($1, .bottom($0)) })
    }

    var defaultTarget: SolveTarget?

    init(defaultTarget: SolveTarget? = nil,
         @EquationBuilder parts: () -> (MultiplicationGroup, MultiplicationGroup)) {
        self.defaultTarget = defaultTarget
        self.topGroup = parts().0
        self.botGroup = parts().1
    }

    func solve(target: SolveTarget, topValues: [Double], bottomValues: [Double]) -> Double {
        // solve
        switch target {
        case .top(let int):
            assert(topValues.count == topGroup.units.count-1)
            assert(bottomValues.count == botGroup.units.count)
            let bottom = botGroup.evaluate(values: bottomValues)
            return topGroup.solve(index: int, given: topValues, total: bottom)
        case .bottom(let int):
            assert(topValues.count == topGroup.units.count)
            assert(bottomValues.count == botGroup.units.count-1)
            let top = topGroup.evaluate(values: topValues)
            return botGroup.solve(index: int, given: bottomValues, total: top)
        }
    }

    func solve(target: SolveTarget, values: [EquationUnit: Double]) -> Double {
        // find the values
        let topValues = topGroup.units.enumerated().compactMap { index, unit in
            target == .top(index) ? nil : (values[unit] ?? 0)
        }
        let botValues = botGroup.units.enumerated().compactMap { index, unit in
            target == .bottom(index) ? nil : (values[unit] ?? 0)
        }

        return solve(target: target, topValues: topValues, bottomValues: botValues)
    }

    func solve(target: EquationUnit, values: [EquationUnit: Double]) -> Double {
        // find the solve target for the unit
        var solveTarget: SolveTarget = .top(-1)
        if let top = topGroup.units.firstIndex(of: target) {
            solveTarget = .top(top)
        } else if let bot = botGroup.units.firstIndex(of: target) {
            solveTarget = .bottom(bot)
        }
        assert(solveTarget != .top(-1))

        return solve(target: solveTarget, values: values)
    }

    func target(current: SolveTarget) -> SolveTarget {
        // if current is valid, return it. Else, use default or .top(0)
        switch current {
        case .top(let int):
            if int < topGroup.units.count {
                return current
            }
        case .bottom(let int):
            if int < botGroup.units.count {
                return current
            }
        }

        if let defaultTarget {
            return defaultTarget
        }

        return .top(0)
    }

    subscript (role: SolveTarget) -> EquationUnit {
        switch role {
        case .top(let int):
            return topGroup.units[int]
        case .bottom(let int):
            return botGroup.units[int]
        }
    }
}

enum SolveTarget: Equatable, Hashable {
    case top(Int)
    case bottom(Int)
}

@resultBuilder
struct UnitBuilder {
    static func buildBlock(_ components: EquationUnit...) -> [EquationUnit] {
        Array(components)
    }
}

@resultBuilder
struct EquationBuilder {
    static func buildBlock(_ components: MultiplicationGroup...) -> (MultiplicationGroup, MultiplicationGroup) {
        assert(components.count == 2)
        return (components[0], components[1])
    }
}
