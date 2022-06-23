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

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
