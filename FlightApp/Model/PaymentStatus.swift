//
//  PaymentStatus.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-26.
//

import SwiftUI

enum PaymentStatus: String, CaseIterable {
    case started = "Connected..."
    case initiated = "Secure payment..."
    case finished = "Purchased"
    
    var symbolImage: String {
        switch self {
            case .started:
                return "wifi"
            case .initiated:
                return "checkmark.shield"
            case .finished:
                return "checkmark"
        }
    }
}

