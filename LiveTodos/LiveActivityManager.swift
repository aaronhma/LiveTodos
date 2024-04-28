//
//  LiveActivityManager.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import Foundation
import ActivityKit

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
        var todo: String
        var startTime: Date
        var endTime: Date
    }
}

enum LiveActivityManagerError: Error {
    case failedToGetId
}

class LiveActivityManager {
    @discardableResult
    static func startActivity(emoji: String, todo: String, startTime: Date, endTime: Date) throws -> String {
        var activity: Activity<LiveActivityAttributes>?
        let initialState = LiveActivityAttributes.ContentState(emoji: emoji, todo: todo, startTime: startTime, endTime: endTime)
        
        do {
            activity = try Activity.request(attributes: LiveActivityAttributes(), contentState: initialState, pushType: nil)
            guard let id = activity?.id else { throw LiveActivityManagerError.failedToGetId }
            return id
        } catch {
            throw error
        }
    }
    
    static func endAllActivities() async {
        for activity in Activity<LiveActivityAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    static func endActivity(_ id: String) async {
        await Activity<LiveActivityAttributes>.activities.first(where: { $0.id == id })?.end(dismissalPolicy: .immediate)
    }
    
    static func updateActivity(id: String, emoji: String, todo: String, startTime: Date, endTime: Date) async {
        let updatedContentState = LiveActivityAttributes.ContentState(emoji: emoji, todo: todo, startTime: startTime, endTime: endTime)
        let activity = Activity<LiveActivityAttributes>.activities.first(where: { $0.id == id })
        await activity?.update(using: updatedContentState)
    }
}
