//
//  ShopTypeStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI
import SwiftUINavigation

public struct ShopTypeStrip<ShopTypeView, ShopTypeDestination>: View
where ShopTypeView: View,
      ShopTypeDestination: View {
    
    @ObservedObject private var viewModel: ShopTypeStripViewModel
    
    private let shopTypeView: (ShopType) -> ShopTypeView
    private let shopTypeDestination: (ShopType) -> ShopTypeDestination

    public init(
        viewModel: ShopTypeStripViewModel,
        shopTypeView: @escaping (ShopType) -> ShopTypeView,
        shopTypeDestination: @escaping (ShopType) -> ShopTypeDestination
    ) {
        self.viewModel = viewModel
        self.shopTypeView = shopTypeView
        self.shopTypeDestination = shopTypeDestination
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.shopTypes, content: shopTypeTileView)
            }
            .padding(.horizontal)
        }
        .navigationDestination(
            unwrapping: .init(
                get: { viewModel.route },
                set: { viewModel.navigate(to: $0) }
            )
        ) { route in
            switch route.wrappedValue {
            case let .shopType(shopType):
                shopTypeDestination(shopType)
            }
        }
    }
    
    private func shopTypeTileView(shopType: ShopType) -> some View {
        shopTypeView(shopType)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.navigate(to: shopType)
            }
    }
}

struct ShopTypeStrip_Previews: PreviewProvider {

    private static func shopTypeStrip(
        route: ShopTypeStripViewModel.Route? = nil
    ) -> some View {
        NavigationStack {
            VStack {
                ShopTypeStrip(
                    viewModel: .init(shopTypes: .preview, route: route),
                            shopTypeView: shopTypeImageView,
                    shopTypeDestination: shopTypeDestination
                )

                Spacer()
            }
        }
    }

    private static func shopTypeImageView(shopType: ShopType) -> some View {
        VStack {
            Color.pink
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))

            Text(shopType.title)
                .font(.caption)
        }
    }

    private static func shopTypeDestination(shopType: ShopType) -> some View {
        Text("TBD: shops in shopType \"\(shopType.title)\"")
    }

    static var previews: some View {
        Group {
            shopTypeStrip()
            shopTypeStrip(route: .shopType(.preview))
        }
        .preferredColorScheme(.dark)
    }
}
