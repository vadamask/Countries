//
//  FavoritesCountriesView.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//
import SwiftData
import SwiftUI
import WidgetKit

struct FavoritesCountriesView: View {
    @Query(filter: #Predicate<CountryModel> {$0.isFavorite})
    private var favoritesCountries: [CountryModel]
    private let appGroupIdentifier = "group.countries.shared"
    private let favoritesKey = "favoritesCountries"
    
    var body: some View {
        if favoritesCountries.isEmpty {
            ContentUnavailableView {
                Label("No favorites", systemImage: "info.circle.fill")
            } description: {
                Text("Add country to favorite to appear here.")
            }
        } else {
            List {
                ForEach(favoritesCountries) { country in
                    CountryRow(model: country)
                }
                .onDelete { set in
                    guard let index = set.first else { return }
                    favoritesCountries[index].isFavorite = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
                            let encodedData = try? JSONEncoder().encode(favoritesCountries.map { $0.commonName })
                            userDefaults.set(encodedData, forKey: favoritesKey)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }
                }
            }
        }
    }
}
