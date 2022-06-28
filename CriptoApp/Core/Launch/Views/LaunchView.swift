//
//  SwiftUIView.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 27/06/22.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portofolio...".map{String($0)}
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    
    @Binding var showLaunchView: Bool
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            if showLoadingText {
                withAnimation(.easeIn) {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                        .offset(y: 70)
                    }
                }
            }
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation {
                counter += 1
                if counter == loadingText.count {
                    showLaunchView.toggle()
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(false))
            .preferredColorScheme(.dark)
    }
}
