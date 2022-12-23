//
//  AddNewAddressView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

public struct AddNewAddressView: View {
    
    @ObservedObject private var viewModel: AddNewAddressViewModel
    
    public init(viewModel: AddNewAddressViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddNewAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewAddressView(viewModel: .init())
            .preferredColorScheme(.dark)
    }
}
