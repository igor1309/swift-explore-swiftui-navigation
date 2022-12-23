//
//  Shops+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections

#if DEBUG
public extension Shops {
    
    static let preview: Self = .init(uniqueElements: [Shop].preview)
}

private extension Array where Element == Shop {

    static let preview: Self = [
        .preview,
        .init(title: "Е-Аптека", shopType: .farmacy),
        .init(title: "Ашан", shopType: .hyper),
        .init(title: "Лента", shopType: .hyper),
        .init(title: "Магнит", shopType: .hyper),
        .init(title: "Пятерочка", shopType: .hyper),
        .init(title: "Перекресток", shopType: .hyper),
        .init(title: "Вкусвил", shopType: .hyper),
        .init(title: "Технопарк", shopType: .gadgets),
        .init(title: "Бетховен", shopType: .zoo),
        .init(title: "Зоогалерея", shopType: .zoo),
        .init(title: "Столетов", shopType: .farmacy),
        .init(title: "Твой дом", shopType: .house),
        .init(title: "Улыбка радуги", shopType: .house),
        .init(title: "Интернет аптека", shopType: .farmacy),
        .init(title: "Мосцветторг", shopType: .flower),
        .init(title: "Мр. Букет", shopType: .flower),
    ]
}
#endif
