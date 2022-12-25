//
//  XCTestCase+assertAsImage.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import SnapshotTesting
import SwiftUI
import XCTest

/// [Episode #41: A Tour of Snapshot Testing](https://www.pointfree.co/collections/tours/snapshot-testing/ep41-a-tour-of-snapshot-testing)
extension XCTestCase {
    
    func assertAsImage(
        _ attributedString: AttributedString,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        let text = Text(attributedString)
        let view = try XCTUnwrap(UIHostingController(rootView: text).view, file: file, line: line)
        assertSnapshot(matching: view, as: .image(size: view.intrinsicContentSize), record: recording, file: file, testName: testName, line: line)

    }
}
