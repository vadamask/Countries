//
//  Configuration.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//

import Foundation

final class Configuration {
    static var baseURL: URL? {
        let urlString = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
        return URL(string: urlString)
    }
}
