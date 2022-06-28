//
//  sdsd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 27/06/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var showSettingsView: Bool
    
    let defaultURL = URL(string: "www.google.com")!

    var body: some View {
        NavigationView {
            List {
                InfoSection
                CoinGeckoSection
            }
            .font(.headline)
            .listStyle(.grouped)
            .tint(Color.blue)
            .navigationTitle("Settigns")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(showView: _showSettingsView)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(false))
    }
}

extension SettingsView {
    
    private var InfoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This is a description off the app. It uses MVVM Architecture, Combine and CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on Facebook", destination: defaultURL)
            Link("Contact on WhatsApp", destination: defaultURL)
        } header: {
            Text("Cripto App")
        }
    }
    
    private var CoinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This is a description off the API used.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on CoinGecko", destination: defaultURL)
        } header: {
            Text("CoinGecko")
        }
    }
}
