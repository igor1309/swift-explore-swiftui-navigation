//
//  CategoryStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Categories = IdentifiedArrayOf<Category>

public struct CategoryStrip<ImageView: View>: View {
    
    @ObservedObject private var viewModel: CategoryStripViewModel
    
#warning("move to injector")
    private let width: CGFloat
    private let height: CGFloat
    private let imageView: (Category) -> ImageView
    
    public init(
        viewModel: CategoryStripViewModel,
        width: CGFloat = 80,
        height: CGFloat = 60,
        imageView: @escaping (Category) -> ImageView
    ) {
        self.viewModel = viewModel
        self.width = width
        self.height = height
        self.imageView = imageView
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories, content: categoryView)
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
    
    private func categoryView(category: Category) -> some View {
        VStack {
            imageView(category)
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(category.title)
                .font(.caption)
        }
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
                    viewModel: .init(categories: .preview, route: route)
                ) { _ in Color.pink.opacity(0.5) }
                
                Spacer()
            }
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
