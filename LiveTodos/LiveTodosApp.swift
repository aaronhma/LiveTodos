//
//  LiveTodosApp.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

@main
struct LiveTodosApp: App {
    @StateObject private var todosStore = TodosStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(todosStore)
        }
    }
}
