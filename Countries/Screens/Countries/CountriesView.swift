//
//  CountriesView.swift
//  Countries
//
//  Created by Вадим Шишков on 12.07.2025.
//
import SwiftData
import SwiftUI

struct CountriesView: View {
    @State private var viewModel: CountriesViewModel?
    @State private var searchName = ""
    @State private var searchResults: [CountryModel] = []
    @State private var isSearching = false
    @State private var showAlert = false
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CountryModel.commonName) var countriesQuery: [CountryModel]
    
    var body: some View {
        Group {
            if countriesQuery.isEmpty {
                ProgressView()
                    .tint(.primary)
                    .onAppear {
                        viewModel = CountriesViewModel(context: modelContext)
                        viewModel?.loadCountries()
                    }
            } else {
                List(searchName.isEmpty ? countriesQuery : searchResults, rowContent: { country in
                    NavigationLink {
                        DetailCountryView(model: country)
                    } label: {
                        CountryRow(model: country)
                    }
                })
                .listStyle(.plain)
                .searchable(text: $searchName)
                .onChange(of: searchName, { _, newValue in
                    searchResults = countriesQuery
                        .filter { $0.commonName.lowercased().hasPrefix(newValue.lowercased()) }
                })
            }
        }
        .alert(viewModel?.errorMessage ?? "", isPresented: $showAlert) {}
        .onChange(of: viewModel?.errorMessage) { _, newValue in
            guard newValue != nil else { return }
            showAlert = true
        }
    }
}

