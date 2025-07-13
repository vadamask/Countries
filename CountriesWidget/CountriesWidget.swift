//
//  CountriesWidget.swift
//  CountriesWidget
//
//  Created by Вадим Шишков on 13.07.2025.
//

import WidgetKit
import SwiftUI

struct CountryEntry: TimelineEntry {
    let date: Date
    let names: [String]
}

struct CountryProvider: TimelineProvider {
    private let appGroupIdentifier = "group.countries.shared"
    private let favoritesKey = "favoritesCountries"
    
    func placeholder(in context: Context) -> CountryEntry {
        CountryEntry(date: Date(), names: ["Germany", "France", "Italy", "Spain", "United Kingdom"])
    }

    func getSnapshot(in context: Context, completion: @escaping (CountryEntry) -> ()) {
        if let data = UserDefaults(suiteName: appGroupIdentifier)?.data(forKey: favoritesKey),
           let countries = try? JSONDecoder().decode([String].self, from: data) {
            completion(CountryEntry(date: Date(), names: countries))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if let data = UserDefaults(suiteName: appGroupIdentifier)?.data(forKey: favoritesKey),
           let countries = try? JSONDecoder().decode([String].self, from: data) {
            let entry = CountryEntry(date: Date(), names: countries)
            let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }
}

struct CountriesWidgetEntryView : View {
    var entry: CountryEntry

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(entry.names.prefix(5), id: \.self) { country in
                Text(country)
                    .font(.caption)
                    .minimumScaleFactor(0.5)
                    .padding(5)
            }
        }
    }
}

struct CountriesWidget: Widget {
    let kind: String = "CountriesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountryProvider()) { entry in
            if #available(iOS 17.0, *) {
                CountriesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CountriesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Favorites Countries")
    }
}

#Preview(as: .systemSmall) {
    CountriesWidget()
} timeline: {
    CountryEntry(date: Date(), names: [])
    CountryEntry(date: Date(), names: [])
    
}
