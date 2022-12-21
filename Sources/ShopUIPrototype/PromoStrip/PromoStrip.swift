//
//  PromoStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct PromoStrip<PromoView: View>: View {
    
    let promos: Promos
    let promoView: (Promo) -> PromoView
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(promos, content: promoView)
            }
            .padding(.horizontal)
        }
    }
}

struct PromoStrip_Previews: PreviewProvider {
    static var previews: some View {
        PromoStrip(promos: .preview) { promo in
            Text(promo.id.rawValue.uuidString)
                .font(.caption)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        }
    }
}
