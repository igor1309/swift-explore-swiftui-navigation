//
//  ShopType+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension ShopType {

    static let preview: Self = .flower
    
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
