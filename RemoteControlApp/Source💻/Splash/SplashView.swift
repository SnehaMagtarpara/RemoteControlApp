//
//  SplashView.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI

struct SplashView: View {
    @State private var loaderWidth: CGFloat = 0
    @State private var isAnimating: Bool = true
    
    var body: some View {
        ZStack {
            Color.primaryBg
                .ignoresSafeArea(.all)
            
            // Centered image
            VStack(alignment: .center, spacing: 35) {
                Image("logo")
                
                VStack(alignment: .center, spacing: 7) {
                    Text("Remote Control")
                        .font(.system(size: 28, type: .Bold))
                        .foregroundColor(Color.Primary)
                }
            }
            
            
            
            VStack(alignment: .center) {
                Spacer()
                
                GeometryReader { geometry in
                    ZStack {
                        
                        Rectangle()
                            .fill(isAnimating ? Color.gray.opacity(0.2) : Color.Primary)
                            .frame(height: 4)
                        
                        
                        Rectangle()
                            .fill(Color.Primary)
                            .frame(width: isAnimating ? loaderWidth : 0, height: 4)
                            .onAppear {
                                startLoaderAnimation(geometry: geometry)
                            }
                    }
                    .frame(width: geometry.size.width, height: 4)
                }
                .frame(height: 4)
                .padding(.bottom, 40)
                .padding(.horizontal, 100)
            }
        }
    }
    
    private func startLoaderAnimation(geometry: GeometryProxy) {
        let fullWidth = geometry.size.width
        
        // Start the animation towards full width
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            loaderWidth = fullWidth
        }
        
        // Stop animation after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            isAnimating = false
            stopLoaderAnimation()
        }
    }
    
    private func stopLoaderAnimation() {
        
        withAnimation(.easeInOut(duration: 20)) {
            loaderWidth = 0
        }
    }
}

#Preview {
    SplashView()
}
