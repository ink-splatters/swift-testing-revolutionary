import Foundation
import SwiftSyntax

/// Rewriter to rewrite test XCTestCase class into swift-testing struct
final class TestClassRewriter: SyntaxRewriter {
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard guessWhetherTestCaseClass(node) else {
            return super.visit(node)
        }
        
        // We can't convert ClassDecl to StructDecl, so we just replace some parameters instead.
        let newNode = node
            .with(\.classKeyword, .keyword(.struct, trailingTrivia: .spaces(1)))
            .with(\.modifiers, []) // get rid of 'final' keyword
            .with(\.inheritanceClause, InheritanceClauseSyntax(
                colon: .unknown(""),
                inheritedTypes: [],
                trailingTrivia: .spaces(1))
            )
        
        return DeclSyntax(newNode)
    }
    
    /// Guess the passed ClassDecl would be TestCase class or not
    private func guessWhetherTestCaseClass(_ node: ClassDeclSyntax) -> Bool {
        guard let inheritedTypeSyntaxNode = node.traverse(kinds: [.inheritanceClause, .inheritedTypeList, .inheritedType], as: InheritedTypeSyntax.self) else {
            return false
        }
        guard let superClassNameToken = inheritedTypeSyntaxNode.firstToken(viewMode: .sourceAccurate) else {
            return false
        }
        
        // If its super-class is `XCTestCase`, it must be a test case
        if superClassNameToken.tokenKind == .identifier("XCTestCase") {
            return true
        }
        
        // Even not, if its name is ended with `Tests`, it might be a test case
        let className = node.name.text
        return className.hasSuffix("Tests") || className.hasSuffix("Test")
    }
}
