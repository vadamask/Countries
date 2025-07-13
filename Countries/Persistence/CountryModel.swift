//
//  CountryModel.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//

import Foundation
import SwiftData

@Model
final class CountryModel {

    var officialName: String
    var commonName: String
    var currencies: [String]
    var capital: [String]
    var region: String
    var languages: [String]
    var latitude: Double
    var longitude: Double
    var flagPngURL: URL?
    var population: Int
    var timezones: [String]
    var isFavorite: Bool = false
    
    init(officialName: String, commonName: String, currencies: [String], capital: [String], region: String, languages: [String], latitude: Double, longitude: Double, flagPngURL: URL? = nil, population: Int, timezones: [String], isFavorite: Bool) {
        self.officialName = officialName
        self.commonName = commonName
        self.currencies = currencies
        self.capital = capital
        self.region = region
        self.languages = languages
        self.latitude = latitude
        self.longitude = longitude
        self.flagPngURL = flagPngURL
        self.population = population
        self.timezones = timezones
        self.isFavorite = isFavorite
    }
    
    func convertToString() -> String {
        """
        \(NSLocalizedString("Country.CommonName", comment: "")): \(commonName)
        \(NSLocalizedString("Country.OfficialName", comment: "")): \(officialName)
        \(NSLocalizedString("Country.Currencies", comment: "")): \(currencies)
        \(NSLocalizedString("Country.Capital", comment: "")): \(capital)
        \(NSLocalizedString("Country.Region", comment: "")): \(region)
        \(NSLocalizedString("Country.Languages", comment: "")): \(languages)
        \(NSLocalizedString("Country.Population", comment: "")): \(population)
        \(NSLocalizedString("Country.Timezones", comment: "")): \(timezones)
        """
    }
}

