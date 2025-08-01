//
//  BackgoundView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-28.
//

import SwiftUI

struct BackgoundView: View {
    var animator: Animator
    var size: CGSize
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(PaymentStatus.allCases, id: \ .rawValue) { status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(height: 30)
                }
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 : animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: 30, alignment: .top)
            .clipped()
            .zIndex(1)
            
            ZStack {
                ForEach(0..<2) { i in
                    Circle()
                        .fill(Color("BG"))
                        .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.45), radius: 5, x: -5, y: -5)
                        .scaleEffect(animator.ringAnimation[i] ? 5 : 1)
                        .opacity(animator.ringAnimation[i] ? 0 : 1)
                }
                
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.2)
                
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
        }
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initiated {
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 2.5).repeatForever(autoreverses: false)
            ) {
                animator.ringAnimation[0] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(
                    .linear(duration: 2.5).repeatForever(autoreverses: false)) {
                        animator.ringAnimation[1] = true
                    }
            }
        }
        .padding(.bottom, size.height * 0.1)
    }
}
