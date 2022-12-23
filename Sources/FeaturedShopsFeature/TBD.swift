//
//  TBD.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct TBD: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text("TBD: \(title)")
            .font(.subheadline)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .border(.secondary, width: 1)
    }
}

struct TBD_Previews: PreviewProvider {
    static var previews: some View {
        TBD("Delivery Type Picker: All/Quick/Self")
    }
}
