//
//  DetailCountryView.swift
//  Countries
//
//  Created by Вадим Шишков on 12.07.2025.
//
import Kingfisher
import MapKit
import SwiftData
import SwiftUI
import WidgetKit

struct DetailCountryView: View {
    @State private var isFavorite = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    @Query(filter: #Predicate<CountryModel> {$0.isFavorite})
    private var favoritesCountries: [CountryModel]
    
    let model: CountryModel
    private let appGroupIdentifier = "group.countries.shared"
    private let favoritesKey = "favoritesCountries"
    
    var body: some View {
        ScrollView {
            kfImage()
            VStack(alignment: .leading) {
                infoView()
                mapView()
            }
            .font(.system(size: 20))
            .lineLimit(nil)
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isFavorite.toggle()
                    model.isFavorite = isFavorite
                    if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
                        let encodedData = try? JSONEncoder().encode(favoritesCountries.map { $0.commonName })
                        userDefaults.set(encodedData, forKey: favoritesKey)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }) {
                    Image(systemName: model.isFavorite ? "star.fill" : "star")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                ShareLink(item: model.convertToString())
            }
        }
        .onAppear {
            isFavorite = model.isFavorite
        }
        .alert(errorMessage ?? "", isPresented: $showAlert) {}
    }
    
    @ViewBuilder
    private func infoView() -> some View {
        Text(LocalizedStringResource("Country.OfficialName")).bold() +
        Text(": ") +
        Text(model.officialName).foregroundStyle(.accent)
        Spacer()
        
        if !model.capital.isEmpty {
            Text(LocalizedStringResource("Country.Capital")).bold() +
            Text(": ") +
            Text(model.capital, format: .list(type: .and)).foregroundStyle(.accent)
            Spacer()
        }
        
        Text(LocalizedStringResource("Country.Population")).bold() +
        Text(": ") +
        Text(model.population.description).foregroundStyle(.accent)
        Spacer()
        
        if !model.currencies.isEmpty {
            Text(LocalizedStringResource("Country.Currencies")).bold() +
            Text(": ") +
            Text(model.currencies, format: .list(type: .and)).foregroundStyle(.accent)
            Spacer()
        }
        
        if !model.languages.isEmpty {
            Text(LocalizedStringResource("Country.Languages")).bold() +
            Text(": ") +
            Text(model.languages, format: .list(type: .and)).foregroundStyle(.accent)
            Spacer()
        }
        
        Text(LocalizedStringResource("Country.Timezones")).bold() +
        Text(": ") +
        Text(model.timezones, format: .list(type: .and)).foregroundStyle(.accent)
        Spacer()
    }
    
    private func kfImage() -> some View {
        KFImage(model.flagPngURL)
            .placeholder({
                ProgressView()
            })
            .roundCorner(radius: .heightFraction(0.1))
            .serialize(as: .PNG)
            .onSuccess { result in
                print("Image loaded from cache: \(result.cacheType)")
            }
            .onFailure { error in
                let nsError = error as NSError
                if nsError.code == NSURLErrorTimedOut || nsError.code == 2003 {
                    errorMessage = NSLocalizedString("Error.Timeout", comment: "")
                } else if nsError.code == NSURLErrorNotConnectedToInternet {
                    errorMessage = NSLocalizedString("Error.NoInternetConnection", comment: "")
                } else {
                    errorMessage = NSLocalizedString("Error.Default", comment: "")
                }
                showAlert = true
            }
            .padding(.vertical)
    }
    
    private func mapView() -> some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: model.latitude,
                        longitude: model.longitude
                    ),
                    latitudinalMeters: 100000,
                    longitudinalMeters: 100000
                )
            )
        ) {}
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical)
    }
}

