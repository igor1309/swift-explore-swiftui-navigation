//
//  ShopView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct ShopView: View {
    
    let shop: Shop
    
    var body: some View {
        VStack {
            Text("Shop View for shop \"\(shop.title)\"")
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Spacer()
        }
        .navigationTitle("Shop Name")
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(shop: .preview)
    }
}
