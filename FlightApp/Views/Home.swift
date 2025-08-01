//
//  Home.swift
//  FlightApp
//
//  Created by Madusanka I M on 2025-07-23.
//

import SwiftUI

struct Home: View {
    
    // MARK: View Bounds
    var size: CGSize
    var safeArea: EdgeInsets
    
    // MARK: Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentCardIndex: CGFloat = 0
    // MARK: Animator State Object
    @StateObject var animator:Animator = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    }
                    .opacity(animator.startAnimation ? 0 : 1)
                    .offset(x: -15, y: 15)
                })
                .zIndex(1)
            CreditCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity,  maxHeight: .infinity)
        .background(content: {
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        Group {
                            // Cloud Views
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.5, size: size)
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 0, size: size)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                if animator.showLoadingView {
                    BackgoundView(animator: animator, size: size)
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        })
        // When ever the final View shows up disabling the actions the Overlay View
        .allowsHitTesting(!animator.showFinalView)
        .background(content: {
            // Safety Check
            if animator.startAnimation {
                DetailView(size: size, safeArea: safeArea)
                    .environmentObject(animator)
            }
            
        })
        .overlayPreferenceValue(
            RectKey.self,
            { value in
                if let anchor = value["PLANEBOUNDS"] {
                    GeometryReader { proxy in
                        /// Extracting Rect From Anchor Using Geometry Reader
                        let rect = proxy[anchor]
                        let planeRect = animator.initialPlanePosition
                        let status = animator.currentPaymentStatus
                        // Reset Plane When it Final View Opens
                        let animatioStatus = status == .finished && !animator.showFinalView
                        
                        
                        Image("airplane")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: planeRect.width, height: planeRect.height)
                        // Flight Movement Animation
                            .rotationEffect(
                                .init(degrees: animatioStatus ? -10 : 0 )
                            )
                            .shadow(
                                color: .black.opacity(0.25),
                                radius: 1,
                                x: status == .finished ? -400 : 0,
                                y: status == .finished ? 170 : 0
                            )
                            .offset(x: planeRect.minX, y: planeRect.minY)
                        // Moving Plane a bit down to look like it's center when the 3D Animation is Happening
                            .offset(y: animator.startAnimation ? 50 : 0)
                            .scaleEffect(animator.showFinalView ? 0.8 : 1)
                            .offset(y: animator.showFinalView ? 80 : 0)
                            .onAppear {
                                animator.initialPlanePosition = rect
                            }
                            .animation(.easeInOut(duration: animatioStatus ? 3.5: 1.5), value: animatioStatus)
                    }
                    
                }
            })
        // One Overlayed Clooud Over the Airplane
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        })
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        // Ehenever the Status Chnaged to Finished toggle cloud View
        .onChange(of: animator.currentPaymentStatus) { _ , newValue in
            if newValue == .finished {
                animator.showClouds = true
                
                // Enabling Final View After Some Time
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
            }
        }
    }
    
    // MARK: Top Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
            .padding(.top, 20)
            
            // MARK: Airplane Image View
            Image("airplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
            //Hiding the Original One
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS" : anchor]
                })
                .padding(.bottom, -20)
        }
        .padding([.horizontal, .top], 25)
        .padding(.top, safeArea.bottom)
        .background {
            Rectangle()
                .fill(
                    .linearGradient(
                        colors: [
                            Color("BlueTop"),
                            Color("BlueTop"),
                            Color("BlueBottom")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        ///Applying 3D Rotation
        .rotation3DEffect(
            .init(degrees: animator.startAnimation ? 90 : 0),
            axis: (x: 1, y: 0, z: 0),
            anchor: .init(x: 0.5, y: 0.8)
        )
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    @ViewBuilder
    func CreditCardsView() -> some View {
        VStack {
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        CardView(index: index)
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)
                
                // MARK: Gradient View
                Rectangle()
                    .fill(
                        .linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .clear,
                                .clear,
                                .white.opacity(0.3),
                                .white.opacity(0.7),
                                .white
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .allowsHitTesting(false)
                
                // MARK: Purchase Button
                Button(action: buyTickets) {
                    Text("Confirm $1,536.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color("BlueTop").gradient)
                        }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottom
                )
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
                
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged ({ value in
                    // Decreasing Speed
                    offsetY = value.translation.height * 0.3
                })
                .onEnded ({ value in
                    let translation = value.translation.height
                    withAnimation (.easeInOut) {
                        // MARK: Increasing/Decreasing Index Based on Condition
                        // 110 -> Since Card Height = 200
                        if translation > 0 && translation > 100 {
                            currentCardIndex -= 1
                        }
                        
                        if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 1) {
                            currentCardIndex += 1
                        }
                        offsetY = .zero
                    }
                })
        )
        .background {
            Color(.white)
                .ignoresSafeArea()
        }
        .clipped()
        // Animate Card View
        .rotation3DEffect(
            .init(degrees: animator.startAnimation ? -90 : 0),
            axis: (x: 1, y: 0, z: 0),
            anchor: .init(x: 0.5, y: 0.25)
        )
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    func buyTickets() {
        /// Animate Content
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        // Showing Loading View After Some Time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.7)) {
                animator.showLoadingView = true
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(
        value: inout [String : Anchor<CGRect>],
        nextValue: () -> [String : Anchor<CGRect>]
    ) {
        value.merge(nextValue()) { $1 }
    }
}
