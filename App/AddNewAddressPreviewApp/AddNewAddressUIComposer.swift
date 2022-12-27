//
//  AddNewAddressUIComposer.swift
//  AddNewAddressPreviewApp
//
//  Created by Igor Malyarov on 27.12.2022.
//

import AddNewAddressFeature
import AddressSearchOnMapFeature
import SwiftUI

struct AddNewAddressUIComposer: View {
    
    private let composer: Composer
    
    init(composer: Composer) {
        self.composer = composer
    }
    
    var body: some View {
        AddNewAddressView(viewModel: composer.addNewAddressViewModel) {
            MapView(viewModel: composer.mapViewModel)
        }
    }
}

struct AddNewAddressUIComposer_Previews: PreviewProvider {
    static var previews: some View {
        AddNewAddressUIComposer(composer: .moscowNeighborhood { _ in })
    }
}
