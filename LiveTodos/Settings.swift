//
//  Settings.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Credits") {
                    Label("Aaron Ma", systemImage: "person")
                    Label("Alan Yu", systemImage: "person")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
