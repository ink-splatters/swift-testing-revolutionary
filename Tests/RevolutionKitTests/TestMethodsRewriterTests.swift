import Foundation
import Testing
@testable import RevolutionKit

private let testCaseConversionFixtures: [ConversionTestFixture] = [
    .init(
        """
        func testExample() {
        }
        """,
        """
        @Test func example() {
        }
        """
    ),
    .init(
        """
        @MainActor func testExample() {
        }
        """,
        """
        @Test @MainActor func example() {
        }
        """
    ),

    .init(
        """
        static func testExample() {
        }
        """,
        """
        static func testExample() {
        }
        """
    ),
    .init(
        """
        func notTest() {
        }
        """,
        """
        func notTest() {
        }
        """
    ),
]

private let setUpConversionFixtures: [ConversionTestFixture] = [
    .init(
        """
        func setUp() {
        }
        """,
        """
        init() {
        }
        """
    ),
    .init(
        """
        func setUp() async throws {
        }
        """,
        """
        init() async throws {
        }
        """
    ),
    .init(
        """
        @MainActor func setUp() async throws {
        }
        """,
        """
        @MainActor init() async throws {
        }
        """
    ),
    .init(
        """
        func setUpWithError() {
        }
        """,
        """
        init() throws {
        }
        """
    ),
    .init(
        """
        static func setUp() {
        }
        """,
        """
        static func setUp() {
        }
        """
    ),
]

private let tearDownConversionFixtures: [ConversionTestFixture] = [
    .init(
        """
        func tearDown() {
        }
        """,
        """
        deinit {
        }
        """
    ),
    .init(
        """
        func tearDown() async throws {
        }
        """,
        """
        deinit {
        }
        """
    ),
    .init(
        """
        static func tearDown() {
        }
        """,
        """
        static func tearDown() {
        }
        """
    ),
]

struct TestMethodsRewriterTests {
    private let emitter = StringEmitter()
    
    @Test("TestMethodsRewriter can convert test cases", arguments: testCaseConversionFixtures)
    private func rewriteTestCases(_ fixture: ConversionTestFixture) throws {
        let runner = Runner()
        
        let result = runner.run(for: fixture.source, emitter: StringEmitter())
        #expect(result == fixture.expected)
    }
    
    @Test("TestMethodsRewriter can convert setUp methods", arguments: setUpConversionFixtures)
    private func rewriteSetUps(_ fixture: ConversionTestFixture) throws {
        let runner = Runner()
        
        let result = runner.run(for: fixture.source, emitter: StringEmitter())
        #expect(result == fixture.expected)
    }
    
    @Test("TestMethodsRewriter can convert tearDown methods", arguments: tearDownConversionFixtures)
    private func rewriteTearDowns(_ fixture: ConversionTestFixture) throws {
        let runner = Runner()
        
        let result = runner.run(for: fixture.source, emitter: StringEmitter())
        #expect(result == fixture.expected)
    }
}
