//
//  AddressView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI

public struct AddressView: View {
    
    public let street: String?
    public let selectAddressAction: () -> Void
    
    public init(street: String?, selectAddressAction: @escaping () -> Void) {
        self.street = street
        self.selectAddressAction = selectAddressAction
    }
    
    public var body: some View {
        Group {
            switch street {
            case .none:
                selectAddressButton()
                
            case let .some(street):
                HStack(alignment: .firstTextBaseline) {
                    Text(street)
                    
                    Spacer()
                    
                    selectAddressButton()
                        .labelStyle(.iconOnly)
                }
            }
        }
        .font(.footnote.bold())
    }
    
    private func selectAddressButton() -> some View {
        return Button(action: selectAddressAction) {
            Label("Select Address", systemImage: "house.fill")
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    
    static func addressView(_ street: String? = nil) -> some View {
        AddressView(street: street, selectAddressAction: {})
    }
    
    static var previews: some View {
        VStack {
            addressView()
            addressView(Address.preview.street.rawValue)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
