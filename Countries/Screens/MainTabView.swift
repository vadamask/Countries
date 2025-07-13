//
//  MainTabView.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    CountriesView()
                        .navigationTitle(StringLiteralType(localized: "Countries"))
                        .toolbarBackground(.visible, for: .navigationBar)
                        .navigationBarTitleDisplayMode(.inline)
                }
            } label: {
                Image(systemName: "list.bullet")
            }
            
            Tab {
                NavigationStack {
                    FavoritesCountriesView()
                        .navigationTitle(StringLiteralType(localized: "Favorites"))
                        .toolbarBackground(.visible, for: .navigationBar)
                        .navigationBarTitleDisplayMode(.inline)
                }
            } label: {
                Image(systemName: "star.circle")
            }
        }
        .tint(.accentColor)
        
    }
}

#Preview {
    MainTabView()
}
