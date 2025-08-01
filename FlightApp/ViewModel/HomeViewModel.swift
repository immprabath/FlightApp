//
//  HomeViewModel.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-28.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var offsetY: CGFloat = 0
    @Published var currentCardIndex: CGFloat = 0
    @Published var animator: Animator = .init()
    
    func buyTickets() {
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.7)) {
                self.animator.showLoadingView = true
            }
        }
    }
    
    func handleDragEnd(_ translation: CGFloat) {
        withAnimation(.easeInOut) {
            if translation > 100 {
                currentCardIndex -= 1
            } else if translation < -100 {
                currentCardIndex += 1
            }
            offsetY = 0
        }
    }
    
    func handleDragChange(_ translation: CGFloat) {
        offsetY = translation * 0.3
    }
    
    func handlePaymentStatusChange(_ newValue: PaymentStatus) {
        if newValue == .finished {
            animator.showClouds = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.animator.showFinalView = true
                }
            }
        }
    }
}
