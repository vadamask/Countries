//
//  NetworkService.swift
//  Countries
//
//  Created by Вадим Шишков on 12.07.2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case clientError(String)
    case serverError(String)
}

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchCountries() async throws -> [CountryDTO] {
        guard let baseURL = Configuration.baseURL else {
            return []
        }
        
        let finalURL = baseURL
            .appending(path: Endpoint.all.rawValue)
            .appending(
                queryItems: [URLQueryItem(name: "fields", value: "name,flags,region,capital,population,translations,currencies,languages,timezones,latlng")]
            )
        
        let request = URLRequest(url: finalURL)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if (200..<300) ~= response.statusCode {
                return try decodeJson(data)
            } else if 400..<500 ~= response.statusCode {
                let message = String(data: data, encoding: .utf8) ?? ""
                throw NetworkError.clientError(message)
            } else if 500..<600 ~= response.statusCode {
                let message = String(data: data, encoding: .utf8) ?? ""
                throw NetworkError.serverError(message)
            }
        }
        return []
    }
    
    private func decodeJson<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw CommonError.decodeError
        }
    }
}
