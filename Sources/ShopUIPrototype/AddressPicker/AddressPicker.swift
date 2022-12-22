//
//  AddressPicker.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public struct AddressPicker<NewAddressView: View>: View {
    
    @ObservedObject private var viewModel: AddressPickerModel
    
    private let newAddressView: () -> NewAddressView
    
    public init(
        viewModel: AddressPickerModel,
        newAddressView: @escaping () -> NewAddressView
    ) {
        self.viewModel = viewModel
        self.newAddressView = newAddressView
    }
    
    public var body: some View {
        VStack {
            if viewModel.addresses.isEmpty {
                emptyAddressesView()
            } else {
                listView()
            }
            
            Button(action: viewModel.addAddressAction) {
                Text("NEW_ADDRESS_BUTTON_TITLE", bundle: .module)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
        }
        .navigationTitle(Text("ADRESS_PICKER_NAVIGATION_TITLE", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.route) { route in
            switch route {
            case .newAddress:
                newAddressView()
            }
        }
    }
    
    private func emptyAddressesView() -> some View {
        Color.clear
            .overlay {
                VStack(spacing: 16) {
                    Image(systemName: "house")
                        .imageScale(.large)
                        .font(.system(size: 64).weight(.light))
                    
                    Text("NO_ADDRESSES_IN_PROFILE_MESSAGE", bundle: .module)
                }
                .foregroundColor(.secondary)
            }
    }
    
    private func listView() -> some View {
        List {
            ForEach(viewModel.addresses, content: addressView)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: viewModel.address)
    }
    
    @ViewBuilder
    private func addressView(address: Address) -> some View {
        let labelTitle = "Select address \(address.street.rawValue)"
        let labelImage = "smallcircle.circle"
        let symbolVariants: SymbolVariants = viewModel.isSelected(address) ? .circle.fill : .none
        
        Button {
            viewModel.selectAddress(address)
        } label: {
            HStack(alignment: .firstTextBaseline) {
                Text(address.street.rawValue)
                
                Spacer()
                
                Label(labelTitle, systemImage: labelImage)
                    .labelStyle(.iconOnly)
                    .symbolVariant(symbolVariants)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundColor(viewModel.isSelected(address) ? .primary : .secondary)
    }
}

struct AddressEditorView_Previews: PreviewProvider {
    
    struct Demo: View {
        @State var profile: Profile
        var route: AddressPickerModel.Route?
        
        var body: some View {
            NavigationStack {
                AddressPicker(
                    viewModel: .init(
                        route: route,
                        profile: profile,
                        selectAddress: { profile.address = $0 },
                        addAddressAction: {}
                    )
                ) {
                    Text("Add new address injected view")
                }
            }
        }
    }
    
    static var previews: some View {
        Group {
            Demo(profile: .preview)
            Demo(profile: .preview, route: .newAddress)
            Demo(profile: .noAddresses)
        }
        .preferredColorScheme(.dark)
    }
}
