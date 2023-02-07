//
//  EquationGroup.swift
//  
//
//  Created by Kai Quan Tay on 7/2/23.
//

import Foundation

/// Represents two ``MultiplicationGroup``s as numerator and denominator of a fraction
public struct EquationGroup {
    /// The ``MultiplicationGroup`` representing the numerator of the fraction
    public var topGroup: MultiplicationGroup
    /// The ``MultiplicationGroup`` representing the denominator of the fraction
    public var botGroup: MultiplicationGroup
    /// The ``EquationUnit``s of the ``topGroup`` and the ``botGroup``, with their ``SolveTarget`` role.
    /// Eg `.top(0)` means the unit is the first unit of ``topGroup``.
    public var flatUnits: [(EquationUnit, SolveTarget)] {
        //        topGroup.units + botGroup.units
        topGroup.units.enumerated().map({ ($1, .top($0)) }) +
        botGroup.units.enumerated().map({ ($1, .bottom($0)) })
    }

    /// The default target of this equation. This usually matches up with how the equation is written,
    /// eg `V = IR` would have a default target of `.top(0)` for `V`
    public var defaultTarget: SolveTarget?

    init(defaultTarget: SolveTarget? = nil,
         @EquationBuilder parts: () -> (MultiplicationGroup, MultiplicationGroup)) {
        self.defaultTarget = defaultTarget
        self.topGroup = parts().0
        self.botGroup = parts().1
    }

    /// Solves for a given ``SolveTarget``, given the values for the units in ``topGroup`` and ``botGroup``,
    /// excluding the value for the given target.
    /// - Parameters:
    ///   - target: The ``SolveTarget`` to solve for
    ///   - topValues: The values for the units in ``topGroup``
    ///   - bottomValues: The values for the units in ``botGroup``
    /// - Returns: The solution for the given target
    public func solve(target: SolveTarget, topValues: [Double], bottomValues: [Double]) -> Double {
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

    /// Solves for a given ``SolveTarget``, given the values in a dictionary mapping the values to their corresponding ``EquationUnit``,
    /// excluding the value for the given target. If a value is missing, it defaults to 0.
    /// - Parameters:
    ///   - target: The ``SolveTarget`` to solve for
    ///   - values: The values mapped to their units
    /// - Returns: The solution for the given target
    public func solve(target: SolveTarget, values: [EquationUnit: Double]) -> Double {
        // find the values
        let topValues = topGroup.units.enumerated().compactMap { index, unit in
            target == .top(index) ? nil : (values[unit] ?? 0)
        }
        let botValues = botGroup.units.enumerated().compactMap { index, unit in
            target == .bottom(index) ? nil : (values[unit] ?? 0)
        }

        return solve(target: target, topValues: topValues, bottomValues: botValues)
    }

    /// Solves for a given ``EquationUnit``, given the values in a dictionary mapping the values to their corresponding ``EquationUnit``,
    /// excluding the value for the given target. If a value is missing, it defaults to 0.
    /// - Parameters:
    ///   - target: The ``EquationUnit`` to solve for
    ///   - values: The values mapped to their units
    /// - Returns: The solution for the given target
    public func solve(target: EquationUnit, values: [EquationUnit: Double]) -> Double {
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

    /// Given the current ``SolveTarget``, this function determines if it is still valid for this equation. If it is unvalid
    /// (eg. `.top(2)` for an equation with only 1 top elements), then it returns ``defaultTarget``.
    /// - Parameter current: The proposed target
    /// - Returns: A safe target to use
    public func target(current: SolveTarget) -> SolveTarget {
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

    /// Takes in a role and outputs a unit. If it is invalid, this causes an index out of bounds error.
    public subscript (role: SolveTarget) -> EquationUnit {
        switch role {
        case .top(let int):
            return topGroup.units[int]
        case .bottom(let int):
            return botGroup.units[int]
        }
    }
}

@resultBuilder
public struct EquationBuilder {
    static func buildBlock(_ components: MultiplicationGroup...) -> (MultiplicationGroup, MultiplicationGroup) {
        assert(components.count == 2)
        return (components[0], components[1])
    }
}
