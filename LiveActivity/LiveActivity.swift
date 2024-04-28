//
//  LiveActivity.swift
//  LiveActivity
//
//  Created by Aaron Ma on 4/27/24.
//
import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
        var todo: String
        var startTime: Date
        var endTime: Date
    }
}

@main
struct LiveActivityDynamicIsland: Widget {
    private var value: CGFloat = 0.0
    private var selected: Bool = true
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lockscreen live activity:
            VStack {
                HStack {
                    Text(context.state.emoji)
                        .font(.largeTitle)
                    
                    Text(context.state.todo)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(context.state.endTime, style: .timer)
                        .foregroundStyle(.secondary)
                        .font(.largeTitle)
                }
                
                ProgressView(value: 50, total: 100)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Text(context.state.emoji)
                            .font(.largeTitle)
                        
                        Text(context.state.todo)
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.endTime, style: .timer)
                        .foregroundStyle(.secondary)
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                    //                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.startTime, format: .dateTime.hour().minute())
                        Spacer()
                        //                        Text(context.state.endTime, style: .timer)
                        //                            .foregroundStyle(.secondary)
                        //                            .font(.largeTitle)
                        //                        Spacer()
                        Text(context.state.endTime, format: .dateTime.hour().minute())
                    }
                    
                    ProgressView(value: 50, total: 100)
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                }
            } compactLeading: {
                Text(context.state.emoji)
                    .font(.largeTitle)
            } compactTrailing: {
                ProgressView()
            } minimal: {
                Text(context.state.emoji)
                    .font(.largeTitle)
            }
        }
    }
}
