//
//  MainPage.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct MainPage<
    AddressView: View,
    DeliveryTypePicker: View,
    CategoryStrip: View,
    FeaturedShopsView: View,
    NewFeatureView: View,
    PromoStrip: View,
    ShopGridView: View,
    ProfileButton: View
>: View {
    
    let addressView: () -> AddressView
    let deliveryTypePicker: () -> DeliveryTypePicker
    let categoryStrip: () -> CategoryStrip
    let featuredShopsView: () -> FeaturedShopsView
    let newFeatureView: () -> NewFeatureView
    let promoStrip: () -> PromoStrip
    let shopGridView: () -> ShopGridView
    let profileButton: () -> ProfileButton
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                addressView()
                deliveryTypePicker()
                categoryStrip()
                featuredShopsView()
                newFeatureView()
                promoStrip()
                shopGridView()
            }
        }
        .searchable(text: .constant(""), prompt: "MAIN_PAGE_SEARCH_PROMPT")
        .navigationTitle("Main Page")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbar)
    }
    
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction, content: profileButton)
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainPage() {
                TBD("Address View with edit Button")
            } deliveryTypePicker: {
                TBD("Delivery Type Picker: All/Quick/Self")
            } categoryStrip: {
                TBD("Category Strip: horizontal scroll")
            } featuredShopsView: {
                TBD("Featured Shops View: small grid of 2")
            } newFeatureView: {
                TBD("New Feature View: promo")
            } promoStrip: {
                TBD("Promo Strip")
            } shopGridView: {
                TBD("Shop Grid View")
            } profileButton: {
                Button {
                    
                } label: {
                    Label("Shop Grid View", systemImage: "person.circle")
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
