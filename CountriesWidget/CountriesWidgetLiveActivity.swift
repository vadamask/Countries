//
//  CountriesWidgetLiveActivity.swift
//  CountriesWidget
//
//  Created by Вадим Шишков on 13.07.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountriesWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CountriesWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountriesWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CountriesWidgetAttributes {
    fileprivate static var preview: CountriesWidgetAttributes {
        CountriesWidgetAttributes(name: "World")
    }
}

extension CountriesWidgetAttributes.ContentState {
    fileprivate static var smiley: CountriesWidgetAttributes.ContentState {
        CountriesWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CountriesWidgetAttributes.ContentState {
         CountriesWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CountriesWidgetAttributes.preview) {
   CountriesWidgetLiveActivity()
} contentStates: {
    CountriesWidgetAttributes.ContentState.smiley
    CountriesWidgetAttributes.ContentState.starEyes
}
