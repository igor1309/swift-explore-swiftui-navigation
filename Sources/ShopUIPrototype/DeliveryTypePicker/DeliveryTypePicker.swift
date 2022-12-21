//
//  DeliveryTypePicker.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct DeliveryTypePicker: View {
    
    @Binding var deliveryType: DeliveryType
    
    var body: some View {
        Picker("Delivery Type", selection: $deliveryType) {
            ForEach(DeliveryType.allCases, content: deliveryView)
        }
        .pickerStyle(.segmented)
    }
    
    private func deliveryView(deliveryType: DeliveryType) -> some View {
        Text(deliveryType.rawValue)
    }
}

enum DeliveryType: String, CaseIterable, Identifiable {
    case all, fast, `self`
    
    var id: Self { self }
}

struct DeliveryTypePicker_Previews: PreviewProvider {
    
    struct Demo: View {
        @State private var deliveryType: DeliveryType = .all
        
        var body: some View {
            DeliveryTypePicker(deliveryType: $deliveryType)
        }
    }
    static var previews: some View {
        Demo()
            .previewLayout(.sizeThatFits)
    }
}
