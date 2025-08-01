//
//  Card.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-24.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var cardImage: String
}

var sampleCards: [Card] = [
    .init(cardImage: "card1"),
    .init(cardImage: "card2"),
    .init(cardImage: "card3"),
    .init(cardImage: "card4"),
    .init(cardImage: "card5"),
    .init(cardImage: "card6"),
    .init(cardImage: "card7"),
    .init(cardImage: "card8"),
    .init(cardImage: "card9"),
    .init(cardImage: "card10"),
    .init(cardImage: "card11"),
    .init(cardImage: "card12"),
]
