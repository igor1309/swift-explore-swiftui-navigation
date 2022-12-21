//
//  CategoryStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Categories = IdentifiedArrayOf<Category>

struct CategoryStrip<ImageView: View>: View {
    
    private let categories: Categories
    private let width: CGFloat
    private let height: CGFloat
    private let imageView: (Category) -> ImageView
    
    init(
        categories: Categories,
        width: CGFloat = 80,
        height: CGFloat = 60,
        imageView: @escaping (Category) -> ImageView
    ) {
        self.categories = categories
        self.width = width
        self.height = height
        self.imageView = imageView
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, content: categoryView)
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
    }
}

struct CategoryStrip_Previews: PreviewProvider {
    static var previews: some View {
        CategoryStrip(categories: .preview) { _ in Color.pink.opacity(0.5) }
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
