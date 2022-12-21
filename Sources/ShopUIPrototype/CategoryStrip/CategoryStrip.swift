//
//  CategoryStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Categories = IdentifiedArrayOf<Category>

public struct CategoryStrip<CategoryView: View>: View {
    
    @ObservedObject private var viewModel: CategoryStripViewModel
    
    private let categoryView: (Category) -> CategoryView
    
    public init(
        viewModel: CategoryStripViewModel,
        categoryView: @escaping (Category) -> CategoryView
    ) {
        self.viewModel = viewModel
        self.categoryView = categoryView
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, content: categoryTileView)
            }
            .padding(.horizontal)
        }
        .navigationDestination(unwrapping: $viewModel.route) { route in
            switch route.wrappedValue {
            case let .category(category):
                Text("TBD: shops in category \"\(category.title)\"")
            }
        }
    }
    
    private func categoryTileView(category: Category) -> some View {
        categoryView(category)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.navigate(to: category)
            }
    }
}

struct CategoryStrip_Previews: PreviewProvider {
    
    private static func categoryStrip(
        route: CategoryStripViewModel.Route? = nil
    ) -> some View {
        NavigationStack {
            VStack {
                CategoryStrip(
                    viewModel: .init(categories: .preview, route: route),
                    categoryView: categoryImageView
                )
                
                Spacer()
            }
        }
    }
    
    private static func categoryImageView(category: Category) -> some View {
        VStack {
            Color.pink
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(category.title)
                .font(.caption)
        }
    }
    
    static var previews: some View {
        Group {
            categoryStrip()
            categoryStrip(route: .category(.preview))
        }
        .preferredColorScheme(.dark)
    }
}

#if DEBUG
public extension IdentifiedArrayOf
where Element == Category, ID == Category.ID {
    
    static let preview: Self = .init(uniqueElements: [Category].preview)
}

private extension Array where Element == Category {
    
    static let preview: Self = ["Аптеки", "Алкоголь", "Гипермаркеты", "Для дома", "Зоотовары", "Рынки", "Цветы", "Необычное", "Электроника", "Канцелярия"]
        .map { Category(title: $0) }
}
#endif
