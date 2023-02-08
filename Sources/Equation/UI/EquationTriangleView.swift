//
//  EquationTriangleView.swift
//  Equation
//
//  Created by Kai Quan Tay on 6/2/23.
//

import SwiftUI
import Updating

@available(iOS 15.0, *)
@available(macOS 13.0, *)
public struct EquationTriangleView: View {
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
            VStack {
                // numerator
                HStack {
                    ForEach(Array(equation.topGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        viewForUnit(unit: unit,
                                    unitRole: .top(index))
                    }
                }
                // denominator
                HStack {
                    ForEach(Array(equation.botGroup.units.enumerated()),
                            id: \.offset) { index, unit in
                        viewForUnit(unit: unit,
                                    unitRole: .bottom(index))
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
                UnitTextView(unit.equationSymbol)
                    .font(.title)
                Text(unit.unitPurpose)
                    .truncationMode(.tail)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .foregroundColor(.primary)
            .padding(5)
            .background {
                ZStack {
                    if unitRole != selected {
                        Color.gray
                    }
                }
                .cornerRadius(10)
                .opacity(0.5)
            }
        }
        .buttonStyle(.plain)
        .background {
            if unitRole == selected {
                selectionColor
            }
        }
    }

    var selectionColor: some View {
        Color.green
            .cornerRadius(10)
            .matchedGeometryEffect(id: "selectionThing", in: namespace)
    }
}

@available(iOS 16.0, *)
@available(macOS 13.0, *)
struct EquationTriangleView_Previews: PreviewProvider {
    static var previews: some View {
        EquationTriangleViewWrapper()
    }

    struct EquationTriangleViewWrapper: View {
        @State var equation = EquationGroup.pv2r
        @State var selected: SolveTarget = .top(0)
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
                UnitTextView(unit.unitSymbol, font: .system(.body, design: .serif))
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
