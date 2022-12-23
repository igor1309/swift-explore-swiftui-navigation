//
//  DeliveryTypePicker.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI

public struct DeliveryTypePicker: View {
    
    @Binding private var deliveryType: DeliveryType
    
    public init(deliveryType: Binding<DeliveryType>) {
        self._deliveryType = deliveryType
    }
    
    public var body: some View {
        Picker("Delivery Type", selection: $deliveryType) {
            ForEach(DeliveryType.allCases, content: deliveryView)
        }
        .pickerStyle(.segmented)
    }
    
    private func deliveryView(deliveryType: DeliveryType) -> some View {
        Text(deliveryType.rawValue)
    }
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
            .preferredColorScheme(.dark)
    }
}
