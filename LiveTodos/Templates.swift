//
//  Templates.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Templates: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Templates allow you to save multiple todos at once.")
                }
            }
            .navigationTitle("Templates")
        }
    }
}

#Preview {
    Templates()
}
