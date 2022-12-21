//
//  CategoryStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Categories = IdentifiedArrayOf<Category>

public struct CategoryStrip<CategoryView, CategoryDestination>: View
where CategoryView: View,
      CategoryDestination: View {
    
    @ObservedObject private var viewModel: CategoryStripViewModel
    
    private let categoryView: (Category) -> CategoryView
    private let categoryDestination: (Category) -> CategoryDestination

    public init(
        viewModel: CategoryStripViewModel,
        categoryView: @escaping (Category) -> CategoryView,
        categoryDestination: @escaping (Category) -> CategoryDestination
    ) {
        self.viewModel = viewModel
        self.categoryView = categoryView
        self.categoryDestination = categoryDestination
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
                categoryDestination(category)
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
                    categoryView: categoryImageView,
                    categoryDestination: categoryDestination
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
    
    private static func categoryDestination(category: Category) -> some View {
        Text("TBD: shops in category \"\(category.title)\"")
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
    
    static let preview: Self = [.farmacy, .alcohol, .hyper, .house, .zoo, .market, .flower, .extraordinary, .gadgets, .stationary]
}

public extension Category {
    
    static let farmacy:       Self = .init(title: "Аптеки")
    static let alcohol:       Self = .init(title: "Алкоголь")
    static let hyper:         Self = .init(title: "Гипермаркеты")
    static let house:         Self = .init(title: "Для дома")
    static let zoo:           Self = .init(title: "Зоотовары")
    static let market:        Self = .init(title: "Рынки")
    static let flower:        Self = .init(title: "Цветы")
    static let extraordinary: Self = .init(title: "Необычное")
    static let gadgets:       Self = .init(title: "Электроника")
    static let stationary:    Self = .init(title: "Канцелярия")
}
#endif
