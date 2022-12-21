//
//  AddressPicker.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public final class AddressPickerModel: ObservableObject {

    @Published var route: Route?
    
    public init(route: Route? = nil) {
        self.route = route
    }
    
    public enum Route: Identifiable {
        case newAddress
        
        public var id: Self { self }
    }
}

struct AddressPicker<NewAddressView: View>: View {

    @ObservedObject var viewModel: AddressPickerModel
    
    let profile: Profile
    let selectAddress: (Address) -> Void
    let addAddressAction: () -> Void
    let newAddressView: () -> NewAddressView
    
    var body: some View {
        VStack {
            if profile.addresses.isEmpty {
                emptyAddressesView()
            } else {
                List {
                    ForEach(profile.addresses, content: addressView)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .animation(.easeInOut, value: profile.address)
            }
            
            Button(action: addAddressAction) {
                Text("NEW_ADDRESS_BUTTON_TITLE")
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
        }
        .navigationTitle("ADRESS_PICKER_NAVIGATION_TITLE")
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
                    
                    Text("NO_ADDRESSES_IN_PROFILE_MESSAGE")
                }
                .foregroundColor(.secondary)
            }
    }
    
    @ViewBuilder
    private func addressView(address: Address) -> some View {
        let labelImage = "smallcircle.circle"
        Button {
            selectAddress(address)
        } label: {
            HStack(alignment: .firstTextBaseline) {
                Text(address.street.rawValue)
                
                Spacer()
                
                Label(
                    "Select address \(address.street.rawValue)",
                    systemImage: labelImage
                )
                .labelStyle(.iconOnly)
                .symbolVariant(isSelected(address) ? .fill : .none)
                .symbolVariant(isSelected(address) ? .circle : .none)
            }
        }
        .buttonStyle(.plain)
        .foregroundColor(isSelected(address) ? .primary : .secondary)
    }
    
    private func isSelected(_ address: Address) -> Bool {
        profile.address == address
    }
}

struct AddressEditorView_Previews: PreviewProvider {
    
    struct Demo: View {
        @State var profile: Profile
        var route: AddressPickerModel.Route?
        
        var body: some View {
            NavigationStack {
                AddressPicker(
                    viewModel: .init(route: route),
                    profile: profile,
                    selectAddress: { profile.address = $0 },
                    addAddressAction: {}
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

#if DEBUG
public extension Profile {    
    static let noAddresses: Self = .init()
}
#endif
