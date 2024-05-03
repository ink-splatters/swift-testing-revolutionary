import Foundation
import SwiftSyntax
import SwiftParser

package struct Runner {
    private let globalOptions: GlobalOptions
    private let rewriter: SyntaxRewriter
    
    init(globalOptions: GlobalOptions = .default) {
        self.globalOptions = globalOptions
        self.rewriter = XCTestRewriter(globalOptions: globalOptions)
    }
    
    init(
        globalOptions: GlobalOptions = .default,
        rewriter: SyntaxRewriter
    ) {
        self.globalOptions = globalOptions
        self.rewriter = rewriter
    }
    
    func run<E: Emitter>(for source: String, emitter: E) -> E.EmitType {
        let sourceFile = Parser.parse(source: source)
        let converted = rewriter.rewrite(sourceFile, detach: true)
        return emitter.emit(converted)
    }
}
