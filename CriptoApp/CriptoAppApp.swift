//
//  CriptoAppApp.swift
//  Shared
//
//  Created by Enrique Miguel Bonilla Untiveros on 30/05/22.
//

import SwiftUI

@main
struct CriptoAppApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
                .environmentObject(viewModel)
//                if showLaunchView {
//                    LaunchView(showLaunchView: $showLaunchView)
//                }
            }
        }
    }
}
