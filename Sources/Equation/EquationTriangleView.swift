//
//  EquationTriangleView.swift
//  Equation
//
//  Created by Kai Quan Tay on 6/2/23.
//

import SwiftUI
import Updating

@available(iOS 15.0, *)
@available(macOS 12.0, *)
struct EquationTriangleView: View {
    @Updating var equation: EquationGroup
    @Binding var selected: SolveTarget

    @Namespace var namespace

    init(equation: EquationGroup,
         selected: Binding<SolveTarget>) {
        self._equation = <-equation
        self._selected = selected
    }

    var body: some View {
        HStack {
            viewForUnit(unit: equation[selected], unitRole: selected)
            Image(systemName: "equal")
            VStack {
                HStack {
                    ForEach(Array(equation.topGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        if selected != .top(index) {
                            viewForUnit(unit: unit,
                                        unitRole: .top(index))
                        }
                    }
                }
                HStack {
                    ForEach(Array(equation.botGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        if selected != .bottom(index) {
                            viewForUnit(unit: unit,
                                        unitRole: .bottom(index))
                        }
                    }
                }
                .padding(.top, 10)
            }
            .overlay {
                Color.primary
                    .frame(height: 1)
            }
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
                Text(unit.equationSymbol)
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
                    } else {
                        Color.green
                    }
                }
                .cornerRadius(10)
                .opacity(0.5)
            }
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)
struct EquationTriangleView_Previews: PreviewProvider {
    static var previews: some View {
        EquationTriangleViewWrapper()
    }

    struct EquationTriangleViewWrapper: View {
        @State var equation = EquationGroup {
            MultiplicationGroup {
                EquationUnit.rho
                EquationUnit.l
            }
            MultiplicationGroup {
                EquationUnit.r
                EquationUnit.a
            }
        }
        @State var selected: SolveTarget = .top(1)
        @Namespace var namespace

        @State var numbers: [EquationUnit: Int] = [:]

        var body: some View {
            List {
                Section {
                    HStack {
                        Spacer()
                        EquationTriangleView(equation: equation, selected: $selected)
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
