//
//  UnitTextView.swift
//  
//
//  Created by Kai Quan Tay on 7/2/23.
//

import SwiftUI
import Updating

@available(iOS 15.0, *)
@available(macOS 13.0, *)
public struct UnitTextView: View {
    @Updating var text: String
    @Updating var font: Font

    @available(iOS 16.0, *)
    public init(_ text: String,
                font: Font = .system(.title, design: .serif, weight: .semibold)) {
        self._text = <-text
        self._font = <-font
    }

    @available(iOS 15.0, *)
    public init(_ text: String) {
        self._text = <-text
        self._font = <-.body
    }

    public var body: some View {
        if #available(iOS 16.0, *) {
            content
                .font(font)
        } else {
            content
        }
    }

    var content: some View {
        ZStack {
            Text(strippedText)
                .padding(.trailing, powerText == nil ? 0 : 15)
                .overlay(alignment: .top) {
                    if let powerText {
                        HStack {
                            Spacer()
                            Text(powerText)
                                .scaleEffect(.init(0.8))
                        }
                        .padding(.top, -12)
                    }
                }
                .offset(y: powerText == nil ? 0 : 3)
        }
    }

    var strippedText: String {
        // remove everything after a ^
        if let caretIndex = text.firstIndex(of: "^") {
            return String(text[..<caretIndex])
        }
        return text
    }

    var powerText: String? {
        if let caretIndex = text.firstIndex(of: "^") {
            return String(text[text.index(after: caretIndex)...])
        }
        return nil
    }
}

@available(iOS 15.0, *)
@available(macOS 13.0, *)
struct UnitTestView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTextView("V^2")
            .background {
                Color.cyan
            }
    }
}
