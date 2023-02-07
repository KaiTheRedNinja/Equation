//
//  Equations.swift
//  
//
//  Created by Kai Quan Tay on 7/2/23.
//

import Foundation

public extension EquationGroup {
    public static let vir = EquationGroup {
        MultiplicationGroup {
            EquationUnit.v
        }
        MultiplicationGroup {
            EquationUnit.i
            EquationUnit.r
        }
    }
    public static let qit = EquationGroup {
        MultiplicationGroup {
            EquationUnit.q
        }
        MultiplicationGroup {
            EquationUnit.i
            EquationUnit.t
        }
    }
    public static let wpt = EquationGroup {
        MultiplicationGroup {
            EquationUnit.w
        }
        MultiplicationGroup {
            EquationUnit.p
            EquationUnit.t
        }
    }
    public static let wqv = EquationGroup {
        MultiplicationGroup {
            EquationUnit.w
        }
        MultiplicationGroup {
            EquationUnit.q
            EquationUnit.v
        }
    }
    public static let pvi = EquationGroup {
        MultiplicationGroup {
            EquationUnit.p
        }
        MultiplicationGroup {
            EquationUnit.v
            EquationUnit.i
        }
    }
    public static let pv2r = EquationGroup(defaultTarget: .bottom(0)) {
        MultiplicationGroup {
            EquationUnit.v.squared()
        }
        MultiplicationGroup {
            EquationUnit.p
            EquationUnit.r
        }
    }
    public static let pri2 = EquationGroup {
        MultiplicationGroup {
            EquationUnit.p
        }
        MultiplicationGroup {
            EquationUnit.r
            EquationUnit.i.squared()
        }
    }

    public static let allEquations: [EquationGroup] = [
        .vir,
        .qit,
        .wpt,
        .wqv,
        .pvi,
        .pv2r,
        .pri2
    ]
}
