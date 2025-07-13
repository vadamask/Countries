//
//  CountryDTO.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//

import Foundation

struct CountryDTO: Decodable {
    
    struct Name: Decodable {
        let official: String
        let common: String
    }
    
    struct CurrencyEntity: Decodable {
        let name: String
        let symbol: String
    }
    
    enum CodingKeys: CodingKey {
        case name
        case currencies
        case capital
        case region
        case languages
        case latlng
        case flags
        case population
        case timezones
        case translations
    }
    
    enum FlagKeys: CodingKey {
        case png
    }
    
    let name: Name
    let currencies: [CurrencyEntity]
    let capital: [String]
    let region: String
    let languages: [String]
    let latitude: Double
    let longitude: Double
    let flagPngURL: URL?
    let population: Int
    let timezones: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        capital = try container.decode([String].self, forKey: .capital)
        region = try container.decode(String.self, forKey: .region)
        population = try container.decode(Int.self, forKey: .population)
        timezones = try container.decode([String].self, forKey: .timezones)
        
        let jsonCurrencies = try container.decode([String: CurrencyEntity].self, forKey: .currencies)
        self.currencies = jsonCurrencies.values.sorted { $0.name < $1.name }
        
        let jsonLanguages = try container.decode([String: String].self, forKey: .languages)
        self.languages = jsonLanguages.values.sorted()
        
        let latlng = try container.decode([Double].self, forKey: .latlng)
        self.latitude = latlng.first ?? 0
        self.longitude = latlng.last ?? 0
        
        let flagContainer = try container.nestedContainer(keyedBy: FlagKeys.self, forKey: .flags)
        let pngString = try flagContainer.decode(String.self, forKey: .png)
        flagPngURL = URL(string: pngString)
                
        let translations = try container.decode([String: Name].self, forKey: .translations)
        let locale = Locale.current.language.languageCode?.identifier ?? "en"
        let fallback = try container.decode(Name.self, forKey: .name)
        if locale == "ru" {
            name = translations["rus"] ?? fallback
        } else {
            name = fallback
        }
    }
    
    func convertToModel() -> CountryModel {
        return CountryModel(
            officialName: name.official,
            commonName: name.common,
            currencies: currencies.map {$0.name + " " + $0.symbol},
            capital: capital,
            region: region,
            languages: languages,
            latitude: latitude,
            longitude: longitude,
            flagPngURL: flagPngURL,
            population: population,
            timezones: timezones,
            isFavorite: false
        )
    }
}
