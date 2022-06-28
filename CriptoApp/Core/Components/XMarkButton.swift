//
//  fd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 14/06/22.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var showView: Bool
    
    var body: some View {
        Button {
            showView.toggle()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(showView: .constant(true))
    }
}
