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
/// [Episode #86: SwiftUI Snapshot Testing](https://www.pointfree.co/episodes/ep86-swiftui-snapshot-testing)
/// [Snapshot Testing Tutorial for SwiftUI: Getting Started | Kodeco, the new raywenderlich.com](https://www.kodeco.com/24426963-snapshot-testing-tutorial-for-swiftui-getting-started)
extension XCTestCase {
    
    func assertAsImage(
        _ attributedString: AttributedString,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        try assertAsImage(Text(attributedString), record: recording, file: file, testName: testName, line: line)
    }
    
    func assertAsImage<V: View>(
        _ view: V,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) throws {
        let view = try XCTUnwrap(UIHostingController(rootView: view).view, file: file, line: line)
        assertSnapshot(matching: view, as: .image(size: view.intrinsicContentSize), record: recording, file: file, testName: testName, line: line)
    }
}
