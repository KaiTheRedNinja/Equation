//
//  EquationUnit.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

/// A struct representing a unit, like volts or current.
public struct EquationUnit: Identifiable, Hashable, Equatable {
    public static func == (lhs: EquationUnit, rhs: EquationUnit) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public var id: String { "\(equationSymbol) \(unitSymbol) \(unitName) \(unitPurpose)" }

    /// The original equation symbol
    private let rawEquationSymbol: String
    /// The symbol to display in the equation
    public var equationSymbol: String
    /// The symbol to display as the unit's symbol
    public var unitSymbol: String
    /// The name of the unit
    public var unitName: String
    /// The purpose of the unit
    public var unitPurpose: String

    /// given a value, it calculates the value for the unit.
    /// eg. for V^2, it would input V (volts) and output V squred
    public var unitForValue: (Double) -> Double = { $0 }
    /// given a unit, it calculates the value for the value.
    /// eg. for V^2, it would input V^2 and output V (Volts)
    public var valueForUnit: (Double) -> Double = { $0 }

    init(equationSymbol: String,
         unitSymbol: String,
         unitName: String,
         unitPurpose: String) {
        self.equationSymbol = equationSymbol
        self.rawEquationSymbol = equationSymbol
        self.unitSymbol = unitSymbol
        self.unitName = unitName
        self.unitPurpose = unitPurpose
    }

    /// Marks the unit as a squared. Eg `v.squared()` is voltage squared.
    public func squared() -> EquationUnit {
        var squared = self
        squared.equationSymbol = "\(rawEquationSymbol)^2"
        squared.valueForUnit = { $0 * $0 }
        squared.unitForValue = { sqrt($0) }

        return squared
    }
}

public extension EquationUnit {
    /// Watts
    static let w: EquationUnit = .init(equationSymbol: "W",
                                       unitSymbol: "J",
                                       unitName: "Joules",
                                       unitPurpose: "Work Done")
    /// Potential Difference (voltage)
    static let v: EquationUnit = .init(equationSymbol: "V",
                                       unitSymbol: "V",
                                       unitName: "Volts",
                                       unitPurpose: "Potential Difference")
    /// Current
    static let i: EquationUnit = .init(equationSymbol: "I",
                                       unitSymbol: "A",
                                       unitName: "Ampere",
                                       unitPurpose: "Current")
    /// Charge
    static let q: EquationUnit = .init(equationSymbol: "Q",
                                       unitSymbol: "C",
                                       unitName: "Coulombs",
                                       unitPurpose: "Charge")
    /// Power
    static let p: EquationUnit = .init(equationSymbol: "P",
                                       unitSymbol: "W",
                                       unitName: "Watts",
                                       unitPurpose: "Power")
    /// Time
    static let t: EquationUnit = .init(equationSymbol: "T",
                                       unitSymbol: "s",
                                       unitName: "Seconds",
                                       unitPurpose: "Time")
    /// Resistence
    static let r: EquationUnit = .init(equationSymbol: "R",
                                       unitSymbol: "Ω",
                                       unitName: "Ohms",
                                       unitPurpose: "Resistence")
    /// Resistivity
    static let rho: EquationUnit = .init(equationSymbol: "𝛒",
                                         unitSymbol: "Ωm",
                                         unitName: "Ohm Meters",
                                         unitPurpose: "Resistivity")
    /// Length
    static let l: EquationUnit = .init(equationSymbol: "l",
                                       unitSymbol: "m",
                                       unitName: "Meters",
                                       unitPurpose: "Length")
    /// Cross sectional area
    static let a: EquationUnit = .init(equationSymbol: "A",
                                       unitSymbol: "m^2",
                                       unitName: "Meters Squared",
                                       unitPurpose: "Cross Sectional Area")
}
