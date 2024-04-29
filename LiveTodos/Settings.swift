//
//  Settings.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Settings: View {
    @AppStorage("iCloudSync") private var iCloudSync = AppSettings.iCloudSync
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $iCloudSync) {
                        Label("Sync Across Devices", systemImage: "arrow.triangle.2.circlepath")
                    }
                } header: {
                    Text("Sync")
                } footer: {
                    Text("Sync your todos across all your devices.")
                }
                
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
