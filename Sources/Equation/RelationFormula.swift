//
//  File.swift
//  
//
//  Created by Kai Quan Tay on 6/2/23.
//

import Foundation

//enum RelationFormula: CaseIterable {
//    case vir, qit, wpt, wqv, pvi, pv2r, pri2 // rpla, g1r
//
//    var equation: Equation { RelationFormula.equations[self]! }
//
//    static let equations: [RelationFormula: Equation] = [
//        .vir: .init(value: .v, var1: .i, var2: .r),
//        .qit: .init(value: .q, var1: .i, var2: .t),
//        .wpt: .init(value: .w, var1: .p, var2: .t),
//        .wqv: .init(value: .w, var1: .q, var2: .v),
//        .pvi: .init(value: .p, var1: .v, var2: .i),
//        .pv2r: .init(value: .p, var1: .v2, var2: .r, operation: .div, overrideEvaluation: { target, var1, var2 in
//            switch target {
//            case .value, .var2:
//                return (var1*var1)/var2
//            case .var1:
//                return sqrt(var1*var2)
//            }
//        }),
//        .pri2: .init(value: .p, var1: .r, var2: .i2, overrideEvaluation: { target, var1, var2 in
//            switch target {
//            case .value:
//                return var1*var2*var2
//            case .var1:
//                return var1/(var2*var2)
//            case .var2:
//                return sqrt(var1/var2)
//            }
//        })
//        //            .rpla: .init(value: "R", var1: "pL", var2: "A", operation: .div),
//        //            .g1r: .init(value: "G", var1: "1", var2: "R", operation: .div)
//    ]
//}
