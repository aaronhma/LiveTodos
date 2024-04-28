//
//  Storage.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Todo: Identifiable, Codable {
    var id = UUID()
    var emoji: String
    var todo: String
    var description: String
    var startTime: Date = Date.now
    var endTime: Date = Date.now
    var template: String
}

@MainActor
class TodosStore: ObservableObject {
    @Published var todos: [Todo] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("todos.data")
    }
    
    func load() async throws {
        let task = Task<[Todo], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let todos = try JSONDecoder().decode([Todo].self, from: data)
            return todos
        }
        
        let todos = try await task.value
        
        self.todos = todos
    }
    
    func save(todos: [Todo]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(todos)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func indexOfTodo(withID id: UUID) -> Int? {
        return todos.firstIndex(where: { $0.id == id })
    }
}

