//
//  FlightDetailsView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-25.
//

import SwiftUI

struct FlightDetailsView: View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    
    var body: some View {
        VStack(alignment: alignment,spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FlightDetailsView(
        alignment: .leading,
        place: "Los Angeles",
        code: "LAS",
        timing: "23 Nov, 03:30"
    )
}
