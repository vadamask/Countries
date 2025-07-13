//
//  CountryRow.swift
//  Countries
//
//  Created by Вадим Шишков on 13.07.2025.
//

import Kingfisher
import SwiftUI

struct CountryRow: View {
    let model: CountryModel
    
    var body: some View {
        
        HStack {
            Group {
                KFImage(model.flagPngURL)
                    .placeholder({
                        ProgressView()
                    })
                    .downsampling(size: CGSize(width: 60, height: 40))
                    .roundCorner(radius: .heightFraction(0.1))
                    .serialize(as: .PNG)
                    .onSuccess { result in
                        print("Image loaded from cache: \(result.cacheType)")
                    }
                    .onFailure { error in
                        print("Image download error: \(error)")
                    }
            }
            .frame(width: 60, height: 40)
            
            VStack(alignment: .leading) {
                Text(model.commonName)
                    .font(.headline)
                Text(model.region)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

