//
//  ContentView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

#Preview {
    ContentView()
}
