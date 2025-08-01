//
//  Animator.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-26.
//

import SwiftUI

class Animator: ObservableObject {
    // Animation Properties
    @Published var startAnimation: Bool = false
    // Initial Plane Position
    @Published var initialPlanePosition: CGRect = .zero
    // Payment Status
    @Published var currentPaymentStatus: PaymentStatus = .initiated
    // Ring Status
    @Published var ringAnimation: [Bool] = [false, false]
    // Loading Status
    @Published var showLoadingView: Bool = false
    // Cloud View Status
    @Published var showClouds: Bool = false
    // Final View Status
    @Published var showFinalView: Bool = false
}
