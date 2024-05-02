import Foundation
import SwiftSyntax

protocol Emitter {
    associatedtype EmitType
    
    func emit(sourceFileSyntax: SourceFileSyntax) -> EmitType
}

struct StringEmitter: Emitter {
    typealias EmitType = String
    
    func emit(sourceFileSyntax: SourceFileSyntax) -> EmitType {
        String(bytes: sourceFileSyntax.syntaxTextBytes, encoding: .utf8) ?? ""
    }
}