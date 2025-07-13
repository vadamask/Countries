//
//  CountriesApp.swift
//  Countries
//
//  Created by Вадим Шишков on 11.07.2025.
//
import SwiftData
import SwiftUI

@main
struct CountriesApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: CountryModel.self)
        }
    }
}
