//
//  AddressView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct AddressView: View {
    
    let street: String
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(street)
            
            Spacer()
            
            Button(action: action) {
                Label("Edit Address", systemImage: "pencil.line")
                    .labelStyle(.iconOnly)
            }
        }
        .font(.footnote.bold())
    }
}

struct AddressView_Previews: PreviewProvider {
    
    static func addressView() -> some View {
        AddressView(street: Address.preview.street.rawValue, action: {})
    }
    
    static var previews: some View {
        Group {
            addressView()
                .preferredColorScheme(.dark)
            addressView()
        }
        .previewLayout(.sizeThatFits)
    }
}
