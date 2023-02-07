//
//  EquationUnit.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

struct EquationUnit: Identifiable, Hashable, Equatable {
    static func == (lhs: EquationUnit, rhs: EquationUnit) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: String { "\(equationSymbol) \(unitSymbol) \(unitName) \(unitPurpose)" }

    private let rawEquationSymbol: String
    var equationSymbol: String
    var unitSymbol: String
    var unitName: String
    var unitPurpose: String

    // eg. for V^2, it would input V (volts) and output V squred
    var unitForValue: (Double) -> Double = { $0 }
    // eg. for V^2, it would input V^2 and output V (Volts)
    var valueForUnit: (Double) -> Double = { $0 }

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

    func squared() -> EquationUnit {
        var squared = self
        squared.equationSymbol = "\(rawEquationSymbol)^2"
        squared.valueForUnit = { $0 * $0 }
        squared.unitForValue = { sqrt($0) }

        return squared
    }
}

extension EquationUnit {
    static let w: EquationUnit = .init(equationSymbol: "W",
                                       unitSymbol: "J",
                                       unitName: "Joules",
                                       unitPurpose: "Work Done")
    static let v: EquationUnit = .init(equationSymbol: "V",
                                       unitSymbol: "V",
                                       unitName: "Volts",
                                       unitPurpose: "Potential Difference")
    static let i: EquationUnit = .init(equationSymbol: "I",
                                       unitSymbol: "A",
                                       unitName: "Ampere",
                                       unitPurpose: "Current")
    static let q: EquationUnit = .init(equationSymbol: "Q",
                                       unitSymbol: "C",
                                       unitName: "Coulombs",
                                       unitPurpose: "Charge")
    static let p: EquationUnit = .init(equationSymbol: "P",
                                       unitSymbol: "W",
                                       unitName: "Watts",
                                       unitPurpose: "Power")
    static let t: EquationUnit = .init(equationSymbol: "T",
                                       unitSymbol: "s",
                                       unitName: "Seconds",
                                       unitPurpose: "Time")
    static let r: EquationUnit = .init(equationSymbol: "R",
                                       unitSymbol: "Ω",
                                       unitName: "Ohms",
                                       unitPurpose: "Resistence")
    static let rho: EquationUnit = .init(equationSymbol: "𝛒",
                                         unitSymbol: "Ωm",
                                         unitName: "Ohm Meters",
                                         unitPurpose: "Resistivity")
    static let l: EquationUnit = .init(equationSymbol: "l",
                                       unitSymbol: "m",
                                       unitName: "Meters",
                                       unitPurpose: "Length")
    static let a: EquationUnit = .init(equationSymbol: "A",
                                       unitSymbol: "m^2",
                                       unitName: "Meters Squared",
                                       unitPurpose: "Cross Sectional Area")
}
