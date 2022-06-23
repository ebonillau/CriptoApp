//
//  fd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 14/06/22.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var showPortofolioView: Bool
    
    var body: some View {
        Button {
            showPortofolioView.toggle()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(showPortofolioView: .constant(true))
    }
}
