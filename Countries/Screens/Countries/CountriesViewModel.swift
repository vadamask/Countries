//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Вадим Шишков on 12.07.2025.
//

import Foundation
import SwiftData

enum CommonError: Error {
    case decodeError
}

@Observable
final class CountriesViewModel {
    
    var isLoading = false
    var errorMessage: String?
    private let context: ModelContext
    
    private let networkService = NetworkService.shared
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func loadCountries() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let countries = try await networkService.fetchCountries()
                await MainActor.run {
                    countries.forEach { context.insert($0.convertToModel()) }
                }
                
            } catch NetworkError.clientError(let message) {
                print(message)
                errorMessage = NSLocalizedString("Error.Default", comment: "")
            } catch NetworkError.serverError(let message) {
                print(message)
                errorMessage = NSLocalizedString("Error.ServerError", comment: "")
            } catch {
                let nsError = error as NSError
                if nsError.code == NSURLErrorTimedOut {
                    errorMessage = NSLocalizedString("Error.Timeout", comment: "")
                } else if nsError.code == NSURLErrorNotConnectedToInternet {
                    errorMessage = NSLocalizedString("Error.NoInternetConnection", comment: "")
                } else if nsError.code == NSURLErrorCannotFindHost {
                    errorMessage = NSLocalizedString("Error.NoInternetConnection", comment: "")
                } else {
                    errorMessage = NSLocalizedString("Error.Default", comment: "")
                }
            }
        }
    }
    
}
