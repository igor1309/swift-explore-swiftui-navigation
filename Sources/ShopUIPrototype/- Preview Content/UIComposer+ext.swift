//
//  UIComposer+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension UIComposer {
    
    static func preview(navigation: AppNavigation) -> UIComposer {
        .init(
            navigation: navigation,
            profile: .preview,
            shopTypes: .preview,
            promos: .preview,
            shops: .preview
        )
    }
}
#endif