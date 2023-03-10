//
//  EquationEqualView.swift
//  Equation
//
//  Created by Kai Quan Tay on 6/2/23.
//

import SwiftUI
import Updating

@available(iOS 15.0, *)
@available(macOS 13.0, *)
public struct EquationEqualView: View {
    /// The equation to represent
    @Updating var equation: EquationGroup
    /// The selected unit
    @Binding var selected: SolveTarget

    @Namespace var namespace

    public init(equation: EquationGroup,
         selected: Binding<SolveTarget>) {
        self._equation = <-equation
        self._selected = selected
    }

    public var body: some View {
        HStack {
            viewForUnit(unit: equation[selected], unitRole: selected)
            Image(systemName: "equal")
            VStack {
                // numerator
                HStack {
                    ForEach(Array(equation.topGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        if selected != .top(index) {
                            viewForUnit(unit: unit,
                                        unitRole: .top(index))
                        }
                    }
                }
                // denominator
                HStack {
                    ForEach(Array(equation.botGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        if selected != .bottom(index) {
                            viewForUnit(unit: unit,
                                        unitRole: .bottom(index))
                        }
                    }
                }
                .padding(.top, onlyOneMulGroup ? 0 : 10)
            }
            .padding(.leading, onlyOneMulGroup ? 1 : 0)
            .overlay {
                if !onlyOneMulGroup {
                    Color.primary
                        .frame(height: 1)
                }
            }
        }
    }

    var onlyOneMulGroup: Bool {
        switch selected {
        case .top(_):
            return equation.topGroup.units.count-1 == 0
        case .bottom(_):
            return equation.botGroup.units.count-1 == 0
        }
    }

    @ViewBuilder
    func viewForUnit(unit: EquationUnit,
                     unitRole: SolveTarget) -> some View {
        Button {
            withAnimation {
                selected = unitRole
            }
        } label: {
            VStack {
                UnitTextView(unit.equationSymbol)
                    .font(.title)
                Text(unit.unitPurpose)
                    .truncationMode(.tail)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .matchedGeometryEffect(id: unit.unitPurpose, in: namespace, properties: .size)
            .foregroundColor(.primary)
            .padding(5)
            .background {
                ZStack {
                    if unitRole != selected {
                        Color.gray
                            .opacity(0.5)
                    } else {
                        Color.green
                    }
                }
                .cornerRadius(10)
            }
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 15.0, *)
@available(macOS 13.0, *)
struct EquationEqualView_Previews: PreviewProvider {
    static var previews: some View {
        EquationEqualViewWrapper()
    }

    struct EquationEqualViewWrapper: View {
        @State var equation = EquationGroup.pv2r
        @State var selected: SolveTarget = .top(0)
        @Namespace var namespace

        @State var numbers: [EquationUnit: Int] = [:]

        var body: some View {
            List {
                Section {
                    HStack {
                        Spacer()
                        EquationEqualView(equation: equation, selected: $selected)
                            .frame(height: 170)
                        Spacer()
                    }
                }

                Section {
                    ForEach(equation.flatUnits, id: \.1) { unit, role in
                        if selected != role {
                            viewForUnit(unit: unit)
                        }
                    }
                }

                Section {
                    viewForUnit(unit: equation[selected], computed: true)
                }
            }
        }

        func viewForUnit(unit: EquationUnit, computed: Bool = false) -> some View {
            HStack {
                Text(unit.unitPurpose)
                if computed {
                    Spacer()
                    Text(String(format: "%.2f", result()))
                } else {
                    TextField(unit.unitName, value: .init(get: {
                        numbers[unit] ?? 0
                    }, set: { newValue in
                        numbers[unit] = newValue
                    }), formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
                }
                Text(unit.unitSymbol)
            }
            .matchedGeometryEffect(id: unit.id, in: namespace)
        }

        func result() -> Double {
            let values = numbers.map({ ($0, Double($1)) })
            return equation.solve(target: selected,
                                  values: .init(uniqueKeysWithValues: values))
        }
    }
}
