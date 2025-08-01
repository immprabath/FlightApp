//
//  DetailView.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-25.
//

import SwiftUI

struct DetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @EnvironmentObject var animator: Animator
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                    
                    Text("Your order has submitted successfully")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("We are waiting for your flight confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                }
                
                HStack {
                    FlightDetailsView(place: "Los Angeles", code: "LAS", timing: "23 Nov, 03:30")
                    
                    VStack(spacing: 8) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                        
                        Text("4h 15m")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    FlightDetailsView(
                        alignment: .trailing,
                        place: "New York",
                        code: "NYC",
                        timing: "23 Nov, 07:15"
                    )
                }
                .padding(15)
                .padding(.bottom, 70)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 20)
            .padding([.horizontal, .bottom], 15)
            .offset(y: animator.showFinalView ? 0 : 300)
            .background {
                Rectangle()
                    .fill(Color("BlueTop"))
                    .scaleEffect(animator.showFinalView ? 1 : 0.001, anchor: .top)
                    .padding(.bottom, 80)
            }
            .clipped()
            
            // MARK: Contact Information View
            GeometryReader { geometry in
                ViewThatFits {
                    ContactInformationView()
                    ScrollView(.vertical, showsIndicators: false) {
                        ContactInformationView()
                    }
                }
                .offset(y: animator.showFinalView ? 0 : size.height)
            }
        }
        .animation(
            .easeInOut(duration: animator.showFinalView ? 0.7 : 0.3)
            .delay(animator.showFinalView ? 0.7 : 0),
            value: animator.showFinalView
        )
    }
    
    @ViewBuilder
    func ContactInformationView() -> some View {
        VStack(spacing: 15) {
            HStack {
                InfoView(title: "Flight", subtitle: "AR 580")
                InfoView(title: "Class", subtitle: "Premium")
                InfoView(title: "Aircraft", subtitle: "B 737-900")
                InfoView(title: "Possibility", subtitle: "AR 580")
            }
            
            ContactView(name: "John Doe", email: "johndoe@example.com", profile: "profile")
                .padding(.top, 30)
            ContactView(name: "Jin Doe", email: "jin@example.com", profile: "nopic")
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("$1,536.00")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            .padding(.leading, 15)
            
            // MARK: Home Screen Button
            Button(action: resetAnimationAndView) {
                Text("Go to Home Screen")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(Color("BlueTop").gradient)
                    }
            }
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
            
            
        }
        .padding(15)
        .padding(.top, 20)
    }
    
    // MARK: Contact View
    @ViewBuilder
    func ContactView(name: String, email: String, profile: String) -> some View {
        HStack {
            VStack(alignment: .leading,spacing: 4) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(email)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
        .padding(.horizontal, 15)
    }
    
    // MARK: Info
    @ViewBuilder
    func InfoView(title: String, subtitle: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
        }
        .frame(maxWidth: .infinity)
    }
    
    func resetAnimationAndView() {
        animator.currentPaymentStatus = .started
        animator.showClouds = false
        
        withAnimation(.easeInOut(duration: 0.2)) {
            animator.showFinalView = false
        }
        
        animator.ringAnimation = [false, false]
        animator.showLoadingView = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut) {
                animator.startAnimation = false
            }
        }
    }
}

#Preview {
    DetailView(size: .zero, safeArea: EdgeInsets())
}
