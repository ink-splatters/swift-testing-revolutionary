import Foundation
import XCTest
import Testing

#if swift(<6.0)

// Below Xcode 15.x, we can't run swift-testing directly. I believe it will be unnecesarry since Xcode 16.
final class AllTests: XCTestCase {
    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
}

#endif
