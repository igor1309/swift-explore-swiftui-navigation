//
//  CategoryStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct CategoryStrip<ImageView: View>: View {
#warning("replace with Identified array of")
    private let categories: [Category]
    private let width: CGFloat
    private let height: CGFloat
    private let imageView: (Category) -> ImageView
    
    init(
        categories: [Category],
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
        CategoryStrip(categories: .samples) { _ in Color.pink.opacity(0.5) }
            .preferredColorScheme(.dark)
    }
}

#if DEBUG
#warning("replace with Identified array of")
public extension Array where Element == Category {
    
    static let samples: Self = ["Аптеки", "Алкоголь", "Гипермаркеты", "Для дома", "Зоотовары", "Рынки", "Цветы", "Необычное", "Электроника", "Канцелярия"]
        .map { Category(title: $0) }
}
#endif
