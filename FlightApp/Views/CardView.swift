//
//  CardView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-28.
//

import SwiftUI

struct CardView: View {
    let index: Int
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
            // MARK: Stacked Card Animation
                .rotation3DEffect(
                    .init(degrees: constrainedProgress * 40),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: .bottom
                )
                .padding(.top, progress * -160.0)
            // MARK: Moving Current Card to the Top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            print(index)
        }
    }
}
