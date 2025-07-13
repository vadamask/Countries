//
//  CountriesWidgetBundle.swift
//  CountriesWidget
//
//  Created by Вадим Шишков on 13.07.2025.
//

import WidgetKit
import SwiftUI

@main
struct CountriesWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountriesWidget()
        CountriesWidgetControl()
        CountriesWidgetLiveActivity()
    }
}
