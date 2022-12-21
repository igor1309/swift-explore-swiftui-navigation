//
//  AddressView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct AddressView: View {
    
    let street: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(street)
            
            Spacer()
            
            Button {
                
            } label: {
                Label("Edit Address", systemImage: "pencil.line")
                    .labelStyle(.iconOnly)
            }
        }
        .font(.footnote.bold())
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddressView(street: Address.preview.street.rawValue)
                .preferredColorScheme(.dark)
            AddressView(street: Address.preview.street.rawValue)
        }
        .previewLayout(.sizeThatFits)
    }
}
