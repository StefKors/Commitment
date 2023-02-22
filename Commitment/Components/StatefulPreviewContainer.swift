//
//  StatefulPreviewContainer.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI

struct PreviewBindingWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

struct PreviewBindingWrapper_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBindingWrapper(true) { binding in
            CustomMenu(isExpanded: binding, menu: {
                Button("one", action: {})
                Button("two", action: {})
            }, label: {
                Text("label")
            })
        }
    }
}
