//
//  CloudView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-28.
//

import SwiftUI

struct CloudView: View {
    var delay: Double
    var size: CGSize
    
    @State private var moveCloud: Bool = false
    
    var body: some View {
        ZStack {
            Image("clouds")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            // Duration = Speed of the movement of the Cloud
            withAnimation(.easeInOut(duration: 5.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}

